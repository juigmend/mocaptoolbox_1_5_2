function d1 = mcreduce(d, f, m, n)
% Reduce the number of markers by merging them.
%
% syntax:
%   d1 = mcreduce(d, f, m, n)
%
% input parameters:
%   d: MoCap structure
%   f: fixed markers (will not change)
%   m: merged markers' numbers [ { [ 1 , 2 ] } , { ... } , ... ]
%   n: merged markers' new names { 'name 1' , 'name 2' , ... }
%
% output:
%   d1: reduced-markers mocap structure
%
% example:
%   Reduce MoCap structure d that has 7 markers, so that markers 1 to 4 remain 
%   unchanged, but also markers 2 and 3 are merged into a single marker, and 
%   markers 5 to 7 are merged into another single marker:
%       d1 = mcreduce( d , 1:4 , [ {[2,3]} , {5:7} ] , { 'merged_1' , 'merged_2'} )
%
% VERSION: 30 January 2021
%
% Juan Ignacio Mendoza
% University of Jyväskylä

L_n = length(n);

if length(m) ~= L_n
    error('Input 3 and 4 should have the same cell length.')
end

d1 = mcgetmarker(d,f);
d2 = mcinitstruct( zeros(d.nFrames,3) , d.freq );

for i_n = 1:L_n
    
    these_markers = mcgetmarker(d,m{i_n});
    
    for dim = 1:3
        
        i_col = dim : 3 : ( these_markers.nMarkers * 3 ) ;
        
        d2.data(:,dim) = mean( these_markers.data(:,i_col) , 2 );
    end

    d2.markerName = n(i_n);

    d1 = mcmerge(d1,d2);
end