function  r= bhattacharyya_coeff(m1, m2)
    % Elapsed time is 21.380110 seconds.
    % r =  sum(sqrt(m1.*m2));
    
    % Elapsed time is 20.970316 seconds.
    r = dot(m1,m2) / (norm(m1) * norm(m2));
end

