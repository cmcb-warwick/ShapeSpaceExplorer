% simple function to get marker size dependent from number of points.
function mk = getMarkerSize(N)
mk = 5;
if N>15000, mk =3; end
if N>20000, mk =1; end
end


