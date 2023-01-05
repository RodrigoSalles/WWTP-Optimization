% Predictions with ANN model
function f = teste_pso_ann(x)

global net
 %  modelfile = 'model_ann_3.h5';
 %  net = importKerasNetwork(modelfile);
    f = predict(net,x);
end

