function xp = generate_points_inside_box(NParticles,center,inside_roi,sig_x,sig_y)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    xp = zeros(NParticles,length(center));
    for i = 1:NParticles
        % create a random point inside the ROI
        while true
            new_point = round( center + ([sig_x sig_y].^2).*randn(1,length(center)) );
            if inside_roi.point_inside(new_point)
                break;
            end
        end
        xp(i,:) = new_point; 
    end
end

