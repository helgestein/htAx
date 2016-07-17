function out=xrdbg(in,c,kmax)
%Cite Sonnevelt & Visser
%kmax=2000;
    input=in;
        for k=1:kmax %number of iterations
            for l=2:length(in)-1 %go through all p_l
                m(l-1)=(in(l-1)+in(l+1))/2;
            end
           
            for l=1:length(in)-2 %check if larger according to Sonneveld & Visser 1975
               %adaptive curvature
                if (in(l)>m(l)+c) %with curvature
                    in(l)=m(l);
                end
            end
        end
    out1=in;
    
    clear in;
    in=flipud(input);
    
    for k=1:kmax %number of iterations
            for l=2:length(in)-1 %go through all p_l
                m(l-1)=(in(l-1)+in(l+1))/2;
            end
           
            for l=1:length(in)-2 %check if larger according to Sonneveld & Visser 1975
               %adaptive curvature
                if (in(l)>m(l)+c) %with curvature
                    in(l)=m(l);
                end
            end
        end
    out2=in;
    
    for i=1:length(out1)
        out(i)=mean([out1(i),out2(i)]);
    end
    out=out.';
end