function  r= bhattacharyya_coeff(m1, m2)
  % r = dot(m1,m2) / (norm(m1) * norm(m2));
  r =  sum(sqrt(m1.*m2));
end

