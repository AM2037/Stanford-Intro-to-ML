function [J, grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m

% Bias/Intercept term for input layer
a1 = [ones(m,1) X];
% Multiplying by weights/parameters - transposing for dimens
z2 = a1 * Theta1';
a2 = sigmoid(z2);
% Bias/Intercept for hidden layer
a2 = [ones(size(a1,1),1) a2]; 
% % Function mapping between layers 
z3 = a2 * Theta2';
a3 = sigmoid(z3);


% Compare predictions with actual (y => identity vectors)
y_hat = eye(num_labels);
Y = (y_hat(y,:));

% Regularization
reg = (lambda / (2*m)) * (sum(sum(Theta1(:,2:end).^2)) + sum(sum(Theta2(:,2:end).^2)));


% Cost function (without regularization) 
J = (1/m) * sum(sum((-Y .* log(a3)) - ((1-Y) .* log(1-a3)))) + reg;

% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.

% Calculating error between predicted and actual from output layer 
% Using lowercase delta(L) = a superscript L - y(t) -- L => output vector
L3 = a3 - Y;
% L2 = ((L3 * Theta2(:,2:end)).* sigmoidGradient(z2));
L2 = (L3*Theta2).*sigmoidGradient([ones(size(z2,1), 1) z2]);
L2 = L2(:,2:end);

% Accumulating gradients by multiplying previous delta values of next layer
% with theta matrix of layer l.
Theta2_grad = (1/m) * (L3' * a2);
Theta1_grad = (1/m) * (L2' * a1);

Theta1_grad(:,2:end) = Theta1_grad(:,2:end) + (lambda/m) * Theta1(:,2:end);
Theta2_grad(:,2:end) = Theta2_grad(:,2:end) + (lambda/m) * Theta2(:,2:end);



% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end