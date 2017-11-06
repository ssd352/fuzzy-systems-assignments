function a2()
clc
close all

%%
uod_p = -2:0.05:2;
uod_q = -2:0.05:2;
ss_p = -1:0.02:1;
ss_q = -1:0.02:1;

%[uod_pm, uod_qm] = meshgrid(uod_p, uod_q);
%[ss_pm, ss_qm] = meshgrid(ss_p, ss_q);

gaussianmf = @(x) gaussmf(x, [0.25, 0]) .* double(-1 <= x & x <= 1);
triannglemf = @(x) trimf(x, [-1, 0, 1]);
trapezoidmf = @(x) trapmf(x, [-1, -0.5, 0.5, 1]);
pulsemf = @(x) double(-1 <= x & x <= 1);%@(x)rectangularPulse(x);

%%
mfarr = {
    gaussianmf; 
    triannglemf; 
    trapezoidmf; 
    pulsemf;
    };

uod_mf_name = {
    'Gaussian_UOD';
    'Triangular_UOD';
    'Trapezoidal_UOD';
    'Pulse_UOD';
    };
ss_mf_name = {
    'Gaussian_SS';
    'Triangular_SS';
    'Trapezoidal_SS';
    'Pulse_SS';
    };

dedarr = {
    @(mp, mq) max(1 - mp, min(mp, mq));
    @(mp, mq) max([min(1 - mp, 1 - mq), min(1 - mp, mq), min(mp, mq)]);
    @(mp, mq) max(1 - mp,  mq);
    @(mp, mq) min(mp,  mq);
    @(mp, mq) mp * mq;
    };

%%

calc_draw3(dedarr, mfarr, uod_mf_name, uod_p , uod_q);
calc_draw3(dedarr, mfarr, ss_mf_name, ss_p , ss_q);

%calc_draw3(dedarr, mfarr, uod_mf_name, ded_name, uod_p , uod_q , uod_pm , uod_qm);
%calc_draw3(dedarr, mfarr, ss_mf_name, ded_name, ss_p , ss_q , ss_pm , ss_qm);


end

function calc_draw2(dedarr, mfarr, mf_name, ded_name, p, label)
    for cnt1 = 1:length(mfarr)
            %for cnt2 = 1:length(mfarr)

            func1 = mfarr{cnt1};

            figure
            plot(p, func1(p));
            title('p');
            ylim([-.05, 1.05]);
            savefig([mf_name{cnt1}, '_p_', label, '.fig']);

            figure
            plot(p, func1(p));
            title('q');
            ylim([-.05, 1.05]);
            savefig([mf_name{cnt1}, '_q_', label, '.fig']);
    end
    
    for ded_cnt = 1:length(dedarr)
        for cnt1 = 1:length(mfarr)
            %for cnt2 = 1:length(mfarr)

            func1 = mfarr{cnt1};

            %func2 = mfarr{cnt2};

            dedfun = dedarr{ded_cnt};

            mf = @(p, q)deduce(p, p, func1, func1, dedfun); 

            out = arrayfun(mf, p, p);

            figure
            plot(p, out);
            xlabel(label);
            ylim([-.05, 1.05]);
            title('p => q');
            
            savefig([mf_name{cnt1}, '_', ded_name{ded_cnt}, '_2d.fig'])
            %end
        end
    end
    
end

function calc_draw3(dedarr, mfarr, mf_name, p , q)
    [pm, qm] = meshgrid(p, q);
     for cnt1 = 1:length(mfarr)
            %for cnt2 = 1:length(mfarr)

            func1 = mfarr{cnt1};

            figure
            plot(p, func1(p));
            title('p');
            ylim([-.05, 1.05]);
            savefig([mf_name{cnt1}, '_p', '.fig']);

            figure
            plot(q, func1(q));
            title('q');
            ylim([-.05, 1.05]);
            savefig([mf_name{cnt1}, '_q', '.fig']);
     end

for cnt1 = 1:length(mfarr)
    for ded_cnt = 1:length(dedarr)
        %for cnt2 = 1:length(mfarr)
            
        func1 = mfarr{cnt1};
        
        %func2 = mfarr{cnt2};
        
        dedfun = dedarr{ded_cnt};
        
        mf = @(p, q)deduce(p, q, func1, func1, dedfun); 

        out = arrayfun(mf, pm, qm);

        figure
        surf(pm, qm, out);
        xlabel('p');
        ylabel('q');
        zlabel('p => q');
        shading interp 
        colorbar
        savefig([mf_name{cnt1}, '_3d_', num2str(ded_cnt),'.fig']);
        %end
    end

end
end

function out = deduce(p, q, pf, qf, df)
    mp = pf(p);
    mq = qf(q);
    out = df(mp, mq);%max(1 - mp, min(mp, mq));
end