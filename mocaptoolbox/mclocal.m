function d2 = mclocal(d, m1, m2, m3)
% Rotates each frame of MoCap data so that the plane defined by markers m1, m2 and m3
% has origin in m1, while the line (m1,m2) is on the x-axis and m3 is on the vertical plane.
% This orientation assumes that x is frontal width, y is depth and z is vertical.
%
% syntax:
%   d2 = mclocal(d, m1, m2, m3);
%
% input parameters:
%   d: MoCap structure
%   m1, m2, m3: numbers of the markers that define the horizontal plane
%               m1 will become the origin
%               m2 will lie on the x-axis
%               m3 will define a plane orthogonal to the y-axis.
%
% output:
%   d2: MoCap structure
%
% VERSION: 15 January 2021
%
% Juan Ignacio Mendoza
% University of Jyväskylä

d2 = d;

i_m1_xyz = 3 * m1 + (-2:0) ;
i_m2_xyz = ( 3 * m2 + (-2:0) ) ;
i_m3_yz  = ( 3 * m3 + (-1:1:0) ) ;

for i_dim = 1:3
    
    d2.data(:,i_dim:3:end) = d2.data(:,i_dim:3:end) - d2.data(:,i_m1_xyz(i_dim)); % translate to origin at m1
end

m2_xyz = d2.data(:, i_m2_xyz );
[theta,phi] = cart2sph( m2_xyz(:,1), m2_xyz(:,2) , m2_xyz(:,3) );

for i_row = 1:d.nFrames
    
    d2.data(i_row,:) = mcrotate( d2.data(i_row,:), 180 - ( 180 * theta(i_row) / pi ) , [0 0 1] , [0 0 0] ); % rotate around z
    d2.data(i_row,:) = mcrotate( d2.data(i_row,:), ( -180 * phi(i_row) / pi ), [0 1 0] , [0 0 0] ); % rotate around y
end

m3_yz_rot = d2.data(:, i_m3_yz );
phi_rot = cart2pol( m3_yz_rot(:,1) , m3_yz_rot(:,2)  );

for i_row = 1:d.nFrames
    
    d2.data(i_row,:) = mcrotate( d2.data(i_row,:), ( 270 - 180 * phi_rot(i_row) / pi ), [1 0 0] , [0 0 0] ); % rotate around x
end

d2.other.rotation_traslation = { sprintf('[m1,m2,m3] where \nm1 is origin, \nm2 lies on x axis \nand m3 defines plane orthogonal to y axis') , ...
                                 [m1,m2,m3] };