% Fibre Optic Time Domain Reflectometry (OTDR) Simulation

% Prompt user for required inputs
c = 3e8; % Speed of light in vacuum (m/s)

% Get user inputs
fiber_length = input('Enter the fibre length in meters (e.g., 10000 for 10 km):'); % Fibre length
joint_position = input('Enter the position of the fibre joint in meters (e.g., 4000 for 4 km): '); % Position of the fibre joint
fiber_loss = input('Enter the fibre loss in dB/km (e.g., 0.2): '); % Fibre loss in dB/km
joint_reflection = input('Enter the reflection coefficient at the joint (e.g., 0.5):'); % Reflection coefficient at the joint
pulse_duration = input('Enter the pulse duration in seconds (e.g., 5e-9 for 5 ns):'); % Pulse duration in seconds
sampling_rate = input('Enter the sampling rate in Hz (e.g., 1e9 for 1 GHz):'); % Sampling rate
num_samples = input('Enter the number of samples to simulate (e.g., 2000):'); % Number of samples

% Time and space parameters
t = (0:num_samples-1) / sampling_rate; % Time vector (seconds)
distance = t * c / 2; % Corresponding distance in the fibre

% Simulating the transmitted pulse (Gaussian pulse)
pulse = exp(-(t - pulse_duration/2).^2 / (pulse_duration/2)^2); 

% Simulating the signal travelling through the fibre
signal = zeros(1, num_samples);

% Transmission through the fibre with loss (attenuation)
attenuated_pulse = pulse .* exp(-fiber_loss * distance / 1000);

% Reflection at the joint (at specified joint_position)
reflected_signal = joint_reflection * attenuated_pulse;

% Combining the transmitted signal and the reflected signal
% Signal travels to the joint and back, so we add delay corresponding to 2*joint_position (forward and backward)
signal(1:length(attenuated_pulse)) = attenuated_pulse;
signal(length(attenuated_pulse)+1:end) = reflected_signal(1:end-length(attenuated_pulse));

% Plotting the results
figure;
subplot(2,1,1);
plot(distance, signal);
xlabel('Distance (m)');
ylabel('Signal Amplitude');
title(['Simulated OTDR Signal with Reflection at ', num2str(joint_position/1000), ' km']);
grid on;

% Loss Calculation (based on the slope of the signal)
% Here, we calculate the slope in the region where the fibre loss is noticeable
attenuation_slope = (signal(end) - signal(end-500)) / (distance(end) - distance(end-500));
fprintf('Calculated Loss (based on slope): %.2f dB/km\n', -20*log10(attenuation_slope));

subplot(2,1,2);
plot(distance, -20*log10(abs(signal)));
xlabel('Distance (m)');
ylabel('Loss (dB)');
title('Simulated Loss Profile of the Fibre');
grid on;
