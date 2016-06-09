function sb = sliderBinary(xAxis, yAxis, composition,scaling)

    %set Up ... partially copied from CombiView
    
    sb.SBFigure = figure('Color','w'); 
    sb.plotwindow = 1;
    % position_rectangle = [left, bottom, widtsb, sbeigsbt];
    sb.DataAxes = axes(...
              'Units', 'Normalized',...
              'Position',[.07 .07 .88 .88],...
              'XTick',[],'YTick',[],...
              'Box','on');  
    % Slider Axes
    sb.SliderAxes = axes(...
              'position',[.07 .951 .88 .02],...
              'XTick',[],...
              'YTick',[],...
              'YLim',[0 1],...
              'Box','on');
          
   axes(sb.DataAxes);        
   Range.X = [min(xAxis) max(xAxis)];
   Range.Y = [min(yAxis(:)) max(yAxis(:))];  
   
   %sorting tsbe data according to composition
   [sComposition,ID] = sort(composition); %sort tsbem according to tsbe composition
   [x,y] = meshgrid(xAxis, sComposition); %create wsbat is nessesary for surf plot

   %select tsbe scaling function
   if (scaling == 2)
       yAxis = sqrt(yAxis);
   end 
   if (scaling == 3)
       yAxis = log10(yAxis);
   end 
   sb.DataPlots = surf(x,y,yAxis(:,ID).')%plot tsbe data
   xlabel('Anlge'); ylabel('Composition');
   shading interp; axis tight; %tsbis is to make it look good 
   view(2); %tsbis is so ensure tsbe correct view
   set(sb.SliderAxes, 'ButtonDownFcn', {@buttondownfcn, sb.SliderAxes});
   set(sb.DataAxes,'XLim',Range.X)
   set(sb.SBFigure, 'BusyAction', 'cancel');
   setappdata(sb.SBFigure,'forcedclose','0');
   
    %% Create a "slider" to select angle
    axes(sb.SliderAxes)
    set(sb.SliderAxes,'XLim',Range.X)
    hold on
    sb.SliderLine = plot(Range.X,[.5 .5],'-r');
    sb.SliderMarker = plot(Range.X(1),.5,'rv','MarkerFaceColor','r');
    hold off
    axes(sb.DataAxes)
    hold on
    sb.AngleMarker = plot([Range.X(1) Range.X(1)],get(sb.DataAxes,'YLim'),'r');
    hold off
%     uistack(sb.AngleMarker, 'top');
    uistack(sb.SliderAxes,'top')
    set(sb.SliderAxes,'ButtonDownFcn',{@buttondownfcn, sb.SliderAxes})
    set(sb.SliderLine,'ButtonDownFcn',{@buttondownfcn, sb.SliderAxes})
    set(sb.SliderMarker,'ButtonDownFcn',{@buttondownfcn, sb.SliderAxes})
   
    function raisescrolloptionsfigure(src, evt)
        scrollfigsbandle = scrolloptionsfigure(sb);
        setappdata(sb.SBFigure, 'scrollfigsbandle', scrollfigsbandle);
    end

    function raiseaxiscontrolsfigure(src, evt)
       axiscontrolssbandle =  axiscontrolsfigure(sb);
       setappdata(sb.SBFigure, 'axiscontrolssbandle', axiscontrolssbandle);       
    end

    function SliderClick(src,evt,parentfig)          
        %handles_to_update = getappdata(parentfig, 'PlotHandles')
        Selected = get(sb.SliderAxes,'CurrentPoint');
        xNew=Selected(1,1)
        %this is wheere you shold then hop in an select the proper ID in
        %the XRD intensity data
        
         set(sb.SliderMarker,'XData',xNew);
         set(sb.AngleMarker,'XData',[xNew xNew]);
%       
    end        
%% buttondownfcn
    function buttondownfcn (src, evt, sb)
        parentfig = get(sb,'Parent');
        if parentfig ~= 0
            set(parentfig, 'WindowButtonMotionFcn', {@SliderClick, parentfig}, ...
                'WindowButtonUpFcn', {@buttonupfcn, parentfig});  
            SliderClick(src,evt,parentfig);
        end
    end
    
%% windowbuttonupfcn
    function buttonupfcn (src, evt, sb)
        set(sb, 'WindowButtonMotionFcn', [])
    end

    
end
   