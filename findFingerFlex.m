function [ timeStampMat ] = findFingerFlex( train_dg )
% Description: parse EMG data for finger flex time windows
% Inputs: the finger flex data
% Ouput: a matrix filled with time stamps. each pair of columns 
%         represents 1 finger channel. so the first 2 columns 
%         represent finger 1. the first column in each pair 
%         represent the time stamp for the beginning window and
%         the second column is the end of the window

thres=1;
buf=0.25*1000;               %sec * sample/sec
dur=2.5*1000;                %sec * sample/sec
fing_num=size(train_dg,2);
z=1;
i=1;

for f=1:fing_num
    while i < size(train_dg,1)
        
        if train_dg(i,f)>thres
            t1=i-buf;
            t2=t1+dur;
            timeStampMat(z,2*f-1)=t1; timeStampMat(z,2*f)=t2;
            z=z+1;
            i=t2+1;
        else
            i=i+1;
        end
        
    end
    i=1;
    z=1;
end

% %Test Code for this function 
% n=size(train_dg,1);
% num_fing=size(train_dg,2);
% bin_dg=zeros(n,num_fing);
% 
% 
% for i=1:num_fing
%     for j=1:size(ts_mat(:,1:2),1)
%         t1=ts_mat(j,2*i-1);
%         t2=ts_mat(j,2*i);
%         if t1==0 && t2==0
%             break;
%         end
%         bin_dg(t1:t2,i)=1;
%     end
% end
% 
% i=1;
% subplot(2,1,1), plot(train_dg(:,i))
% subplot(2,1,2), plot(bin_dg(:,i))

end



