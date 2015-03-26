%% doRand: function description
function [outputs] = doRand(max ,min)
    a  = rand();
    outputs = min  + (max - min) * a;  
 