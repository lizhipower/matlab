function [ t_system , status_system ] = dsMCyear( tempOP )
    eleNum = length (tempOP);
    lam = ones(1, eleNum) * 0.4;
    dur = ones(1, eleNum) * 10;
    miu = 8760 ./ dur;

    lam = lam / 8760;
    miu = miu / 8760;

    %����ϵͳԪ����ʼ��������������״̬

    status_system(1 , :) = ones(1 , eleNum);

    %һ�η���һ���״̬����
    %t_branch������¼����Ԫ����һ״̬�ı��ʱ��
    %0ʱ�̼�Ϊ��ʼʱ��

    t_system = [0];%��¼ϵͳ״̬�ı��ʱ��

    t_branch = zeros(eleNum , 1);%��¼ϵͳԪ����һ��״̬�ı��ʱ��


    t_branch = -1 ./ lam' .* log(rand(eleNum , 1));

    % status_temp = ones(eleNum , 1);
     % status_temp = status_system;
    status_temp = ones(eleNum , 1);
    status_system = status_temp;

    while max(t_system) < 8760
        [t index]= min(t_branch);
        t_system = [t_system t];
        status_temp(index , 1) = xor(status_temp(index , 1),1);
        status_system = [status_system status_temp];

        if status_temp(index , 1) == 1
            m = -1/lam(index)*log(rand);
            t_branch(index) = t_branch(index) + m;
        else
            r = -1/miu(index)*log(rand);
            t_branch(index) = t_branch(index) + r;
        end

    end
    % status_system = status_system';

    % dsMCOP

end

