function xp = generate_points_inside_box(NParticles,center,inside_roi,sig_x,sig_y)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    xp = zeros(NParticles,length(center));
    pos = 1
    for ii = 1:NParticles
        % create a random point inside the ROI
        new_point = round( center + ([sig_x sig_y].^2).*randn(1,length(center)) );
        if inside_roi.point_inside(new_point)
           xp(pos,:) = new_point;
           pos = pos+1;
        end 
    end
end

