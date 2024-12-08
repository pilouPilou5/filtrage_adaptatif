function varargout = init_ISI(block, varargin)
% Censée initialiser les paramètres du block
% 
eStr.ecode = 0;
eStr.emsg  = '';
eStr.emsg_w = '';

varargout{1} = eStr;

    if(strcmp(get_param(bdroot(gcb),'simulationstatus'),'stopped'))
      
            % --- Set Init Values
    %SETFIELDINDEXNUMBERS(gcb);
    setfieldindexnumbers(gcb);
    Vals=get_param(gcb,'MaskValues');

    %--- Assigin Variables to workspace
    assignin('base','Tech',str2num(Vals{idxTech}));
    assignin('base','Tfinal',str2num(Vals{idxTfinal}));
    assignin('base','Mconst',str2num(Vals{idxMconst}));
    assignin('base','NumCanal',str2num(Vals{idxNumCanal}));
    assignin('base','SNRcanal',str2num(Vals{idxSNRcanal}));
    assignin('base','NCoeffs',str2num(Vals{idxNCoeffs}));
    assignin('base','Kegal',str2num(Vals{idxKegal}));
    R=((length(str2num(Vals{idxNumCanal})))-1)/2; % retard de groupe du canal
    assignin('base','R',R);
    Regal=((str2num(Vals{idxNCoeffs}))-1)/2; % retard de groupe de l'égalisateur
    assignin('base','Regal',Regal);
    kc=[1:4];
    Constellation=exp(1i*pi*(1+2*kc)/4);
    assignin('base','Constellation',Constellation);
    assignin('base','ModCanal',[1 0.75 0.56 0.42 0.32 0.24 0.18]);
    assignin('base','Limite',2);
    
     % --- Return without error
     varargout{1} = eStr;
            
    end         
