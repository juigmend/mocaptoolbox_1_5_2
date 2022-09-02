function [mf, mm, mgrid] = mcmissing(d)
% Reports missing data per marker and frame. 
%
% syntax
% [mf, mm, mgrid] = mcmissing(d);
%
% input parameters
% d: MoCap or norm data structure.
%
% output
% mf: number of missing frames per marker
% mm: number of missing markers per frame
% mgrid: matrix showing missing data per marker and frame (rows correspond to frames and columns to markers
%
% Part of the Motion Capture Toolbox, Copyright 2008,
% University of Jyvaskyla, Finland

% changes made by Juan Ignacio Mendoza indicated by comments starting with "JIMG"

if isfield(d,'type') && strcmp(d.type, 'MoCap data')
    
    % . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
    % Detect missing data in any dimension, not only the first:
    % (JIMG, 26 January 2021)
       
    all_missing = isnan(d.data);
    mgrid = zeros(d.nFrames,d.nMarkers);
    
    for dim = 1:3
        
        mgrid = mgrid | all_missing( : , dim : 3 : d.nMarkers * 3 );
    end
    
    mf = sum(mgrid,1);
    mm = sum(mgrid,2);
    
    % . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
    
%     mf = sum(isnan(d.data(:,1:3:end)),1);
%     mm = sum(isnan(d.data(:,1:3:end)),2);
%     mgrid = isnan(d.data(:,1:3:end));
elseif isfield(d,'type') && strcmp(d.type, 'norm data')
    mf = sum(isnan(d.data(:,1:end)),1);
    mm = sum(isnan(d.data(:,1:end)),2);
    mgrid = isnan(d.data(:,1:end));
else
    disp([10, 'The first input argument should be a variable with MoCap or norm data structure.', 10]);
    [y,fs] = audioread('mcsound.wav');
    sound(y,fs);
    mf=[];
    mm=[];
    mgrid=[];
end

