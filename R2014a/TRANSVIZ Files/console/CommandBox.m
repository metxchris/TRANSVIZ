function ui = CommandBox(commandStr, cdf, option, variable, ui)
        
    % Do i need to do all this file saving?
        fileName = 'Console Output\Message';
        if ~exist('Console Output','file')
            mkdir('Console Output');
        end
        
        if exist([fileName,'.txt'],'file')
            
            for j=2:99999
                if ~exist([fileName,' (',num2str(j),')','.txt'],'file')
                    fileName = horzcat(fileName,' (',num2str(j),')','.txt');
                    break
                end
            end
            
        else
            fileName = horzcat(fileName,'.txt');
        end
        diary(fileName)

        set(0, 'currentfigure', ui.main.figH);
        try
            if ~strcmp(commandStr,'clc')
                set(gcbo,'string','');
                eval(commandStr)
            else
                set(ui.console.outputH,'string',' ');
                 set(gcbo,'string','');
                return
            end
            errorMsg='';
        catch errorMsg
    
            errorMsgReport = getReport(errorMsg, 'extended','hyperlinks', 'on');
            errorMsgReport=textscan(errorMsgReport, '%s', 'Delimiter','\n');
            
    
            
        end

        set(gcbo,'string','');
        diary off
        
        fid = fopen(fileName,'r');  % Open text file
        ui.console.figH=findobj('type','figure','name','Console');
        ui.console.outputH=findobj(ui.console.figH,'tag','Console Window');
        ui.console.historyH=findobj(ui.console.figH,'tag','Console History');
        oldStr=get(ui.console.outputH,'string');
        oldStrh=get(ui.console.historyH,'string');
        
        if isempty(errorMsg)
            
            str = textscan(fid, '%s', 'Delimiter','\n');
            
            if numel(str)>1
                str(1)=[];
            end
            str=strcat({'       '},str{1});
            
        else
            
            %             str=strsplit(errorMsg,'\n')';
            str=strcat({'<HTML><div style="color:red;link:red;margin-left:16px;">'},errorMsgReport{:,1},{'</div></HTML>'});
        end
        
        
        switch commandStr
            case 'clc'
                %                  set(ui.console.outputH,'value',1);
                set(ui.console.outputH,'value',1)
                set(ui.console.outputH,'string','');
                disp(get(ui.console.outputH,'string'))
                isempty(get(ui.console.outputH,'string'))
                if get(ui.console.outputH,'value')<get(ui.console.outputH,'ListboxTop')
                    set(ui.console.outputH,'ListboxTop',get(ui.console.outputH,'value'))
                    disp('clc if called')
                end
            otherwise
                
                
                str = [oldStr;' ';['>> ',commandStr];str];
                    set(ui.console.historyH,'string',[oldStrh;{commandStr}]);
                set(ui.console.outputH,'string',str);
                if ~isempty(get(ui.console.outputH,'string'))
                index = length(get(ui.console.outputH,'string'));
                end

%                 index(2)
                %                 index2 = numel(get(ui.console.outputH,'string'), 1)%get how many items are in the list box
%                 set(ui.console.outputH,'value',index(1))

                
             
                
               


                %set the index of last item to be the index of the top-most string displayed in list box.
                if get(ui.console.outputH,'value')>get(ui.console.outputH,'ListboxTop')
%                     disp(get(ui.console.outputH,'ListboxTop'))
%                     disp(get(ui.console.outputH,'value'))
%                     set(ui.console.outputH,'value',1)
                    disp('set to 1 on top')
                elseif isempty(get(ui.console.outputH,'value'))
                    set(ui.console.outputH,'value',1)
                    disp('reset to 1')
                    disp(get(ui.console.outputH,'ListboxTop'))
                end
        end

    
        fclose(fid);
         if ~isempty(get(ui.console.outputH,'string'))
                     consoleH = findobj('type','figure','name','Console');
        set(findobj(consoleH,'tag','Console Window'),'ListboxTop',index)
                 else 
             set(ui.console.outputH,'value',1)

         end
        % Make this optional at some point
                delete(fileName);
        
        
        
        
        %         plotEquation();
    end