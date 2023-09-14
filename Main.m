%% Script for 2022 Car Testing 
% 7/25/22 James Caldwell, UVA

% Creates graphs and scaled versions of run data
% Runs with cfc.m (from JP) in workspace folder with the Signal Processing Toolbox for Matlab installed

% Run script such as AccordFront.m before this one
%        Located here: \\cab-fs07.mae.virginia.edu\NewData\Driversiti\1CustomCode\2022 Pulse Generation\Data
% That script outputs time, acceleration data, ROI (start/cutoff), car name, and scale factors. 
% To process a new set of data, download IIHS data and copy time/acc
% numbers into a template of FocusFront.m

% The last section of this script saves time/scaled IIHS acceleration data as a .csv to \\cab-fs07.mae.virginia.edu\NewData\Driversiti\1TestDocs\2022\CSV Pulses


%% CFC 60 Filter. Change .0001 to different dT if needed
accFiltered = zeros(length(scalefactors),length(acc));
accFiltered(1,:) = cfc(acc,.0001,60);

%% Creating scaled down acceleration data for each scale factor
for i=1:length(scalefactors)
    accFiltered(i+1,:)=accFiltered(1,:)*scalefactors(i);
end

%% Calculating Velocity (trapezoidal integration of acceleration)
velocity=zeros(length(scalefactors),length(accFiltered));

for j=1:(length(scalefactors)+1)
    for i=start:cutoff %(length(AccFiltered)-1)
        velocity(j,i)=(accFiltered(j,i)+accFiltered(j,i+1))/2*(time(i+1)-time(i));
    end
end

%% Delta V
deltaV = zeros(length(scalefactors)+1,1);

for i=1:(length(scalefactors)+1)
    %deltaV(i,1) = -sum(velocity(i,:),'all')*(9.81/1000)*3600;
    deltaV(i,1) = sum(velocity(i,start:cutoff),'all')*(9.81/1000)*3600;
end

%% Max Acceleration
maxg = zeros(length(scalefactors)+1,1);
for i=1:(length(scalefactors)+1)
    maxg(i,1) = max(accFiltered(i,start:cutoff));
end

%% Plotting
close all
hold on
for i=1:length(scalefactors)+1
    plot(time(start:cutoff),accFiltered(i,start:cutoff))
end
title('Crash Pulse')
xlabel("Time (sec)")
ylabel("Acceleration (g)")

datalabel{1}="100%";
for i=1:length(scalefactors)
    datalabel{i+1}=num2str(scalefactors(i)*100+"%");
end
legend(datalabel)
grid on
xlim([time(start) time(cutoff)])

%% Summary
Scaling_DeltaV_Maxg = [1, scalefactors;
    deltaV';
    maxg']'

%% Pulse Output into .csv
%Un-comment when you're ready to save time/acc data to .csv File
% 
% time_output = time(start:cutoff);
% acc_output = accFiltered(2:end,start:cutoff)';
% output = zeros(length(acc_output),2);
% 
% for i=1:length(scalefactors)
%     output=[time_output,acc_output(:,i)];
%     %filename=strcat('C:\Users\james.caldwell\OneDrive - University of Virginia\Documents\Pulses\',car,num2str(scalefactors(i)*100),'.csv');
%     filename=strcat('\\cab-fs07.mae.virginia.edu\NewData\Driversiti\1TestDocs\2022\CSV Pulses\',car,num2str(scalefactors(i)*100),'.csv');
%     writematrix(output,filename)
% end
