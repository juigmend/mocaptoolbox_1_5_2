function d = mcreadc3d(fn);

% Adjusted to use readc3d, Created by JJ Loh  2006/09/10-2008/04/10
% Departement of Kinesiology
% McGill University, Montreal, Quebec Canada
% used by permission
%
% read in mocap data using readc3d.m
% convert from readc3d structure to MoCap Toolbox structure

% Modifications by Juan Ignacio Mendoza Garay, indicated with (JIMG)
% University of Jyv?skyl?, October 2018


% read in data from */mocaptoolbox/private/readc3d.m
data = readc3d(fn); 
           
% create MoCap structure
d.type = 'MoCap data';        
d.filename = fn;
d.nFrames = data.Header.EndVideoFrame;
d.nCameras = 0;
d.nMarkers = size(fieldnames(data.VideoData),1);
d.freq = data.Header.VideoHZ;
d.nAnalog = [];%size(AnalogData,2);
d.anaFreq= [];
d.timederOrder = 0;
d.markerName = [];
d.data = [];
d.analogdata = [];%data.AnalogData;
d.other = [];


% organize data
pos = {'xdata','ydata','zdata'};
previous_length = 0;
for x=1:size(fieldnames(data.VideoData),1)
    d.markerName{x,1} = data.VideoData.(strcat('channel',num2str(x))).label;
    for y=1:3
        d_tmp(:,y) = data.VideoData.(strcat('channel',num2str(x))).(pos{y}); 
    end
    
%     % if next marker has less frames, then fill with NaN (JIMG):
%     this_length = size(d_tmp,1);
%     if x > 1 && this_length ~= previous_length
%        d_tmp = [d_tmp; nan(abs(this_length-previous_length),3)];
%     end
    d.data = [d.data d_tmp];

    previous_length = size(d.data,1);
    clear d_tmp
    d.other.residualerror = data.VideoData.(strcat('channel',num2str(x))).residual;
    
end

d.other.event = [];
d.other.parametergroup = data.Parameter;
d.other.camerainfo = [];
disp(strcat(fn,' loaded'))

if data.Header.EndVideoFrame ~= length(d.data) %BBFIX20141202 Optitrack apparently has issues with this.
    disp([10, 'Note: d.nFrames does not match length of d.data. d.nFrames changed accordingly.', 10])
    d.nFrames = length(d.data);
end