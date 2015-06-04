function [temp] = gcon1(new_BRANCH,branch)

[m,Npop]=size(new_BRANCH);

for i=1:Npop

        for j=1:m
            if new_BRANCH(j,i)>=0
                 temp(j,i)=new_BRANCH(j,i)-branch(j,6);   %正向潮流 (F>0)
            else
                 temp(j,i)=-new_BRANCH(j,i)-branch(j,6);  %反响潮流 (F<0)
            end
        end    

end

