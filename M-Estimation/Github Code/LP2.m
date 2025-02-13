function [Out_X, U, V] = LP2(M_Omega,Omega,rak, maxiter)
% This matlab code implements the l1-reg 
% method for Matrix Completion.
%
% M - m x n matrix of observations/data (required input)
%
% Omega is the subset
%
% maxIter - maximum number of iterations
%         - DEFAULT 500, if omitted or -1.

iter = 0;
[n1, n2] = size(M_Omega);
U = randn(n1,rak);
while 1
    iter = iter + 1;
    clear row col V;
    for j = 1: n2
        clear row;
        row_i = find(Omega(2, :) == j); % Omega(2, :) is the row containing column indices of nonzero elements
        % Therefore row_i gives me the indices of the
        % non-zero elements in jth column - denoted by I_1 in paper

        [~,col_n] = size(row_i); % col_n is basically the number of nonzero elements in jth column

        for n = 1: col_n
            row(n, 1) = Omega(1, row_i(1, n)); % Seeing as we have row_i, we can now one by one get the column
            % indices from it and the row indices from subscribting with 1
            % as Omega(1, :) is the row containing row indices of nonzero
            % elements. Therefore, we are extracting all the non-zero
            % indices from the jth column. row(n, 1) therefore is a vector
            % containing all non-zero elements' indices of the jth column. Therefore
            % its of shape R ^ {|I_j|} - same shape as vector 'b'
            % denoted in the paper
        end
        for i = 1: length(row) % For as many nonzero elements' indices, grab the whole row of it and generate a temporary matrix
            % U_I of shape |I_j| x rank
            U_I(i,:) =  U(row(i, 1),:);

            b_I(i) = M_Omega(row(i, 1), j); % contains the non-zero elements from the jth column
        end
        V(:, j) = pinv(U_I) * b_I'; % formula update
        clear U_I b_I;
    end
    clear row col U;
    for i = 1: n1
        clear col;
        col_i_new = find(Omega(1, :) == i);
        [~, col_n] = size(col_i_new);
        for n = 1:col_n
            col(1, n) = Omega(2, col_i_new(1, n));
        end
        for j = 1: length(col)
            V_I(:,j) = V(:, col(1, j));
            b_I(j) = M_Omega(i,col(1, j));
        end
        U(i,:) = b_I * pinv(V_I);
        clear V_I b_I;
    end
    %**************
    %Judging
    %**************
    X = U * V;
    if (iter > maxiter)
        break;
    end
    
end
    Out_X = X;
end