function [ dim ] = dimFromAspect( diagonal, aspect )
% Computes the width and height of screen give diagonal and aspect ratio


dim.y = diagonal / sqrt(aspect^2 + 1);
dim.x = aspect*dim.y;
end

