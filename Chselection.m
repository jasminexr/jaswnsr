
function [x_samples,time,AR,NP]=Chselection(N_samples,type_alg)


switch type_alg
    case 1
      help PARS 
      Delta=0.8;
      [x_samples,time,AR,NP,]=PARS(N_samples,Delta);
end