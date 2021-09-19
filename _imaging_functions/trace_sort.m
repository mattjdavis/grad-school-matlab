function [auc_sort, max_sort, auc_ind] = trace_sort( Flouro)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%To do: check to see matrix input
[f1,f2,f3]=size(Flouro);


    long_trace=reshape(Flouro,f1,f2*f3,[]);
    auc_data=trapz(long_trace,1);
    max_data=max(long_trace);
    [~, auc_ind]=sort(auc_data);
    [~ ,max_ind]=sort(max_data);


    
    %len=length(long_trace); %4.14.15 length gives the largest dim, this
    %causes errors as I want the column size of long trace
    len=size(long_trace,2);
    auc_sort=long_trace(:,auc_ind(1:len));
    max_sort=long_trace(:,max_ind(1:len));


end

