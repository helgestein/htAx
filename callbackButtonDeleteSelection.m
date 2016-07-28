function callbackButtonDeleteSelection(obj, evt, ...
    ternHandles, specHandles, ECHandles)
%CALLBACKBUTTONDELETESELECTION executes the callback for the "Delete
%selection" button, used to delete a user-selected point on the ternary
%plot

    set(ternHandles.buttonDelete, 'Callback', []);

    figTern = ternHandles.fTernDiagram;
    ternInfo = figTern.UserData;
    
    pointInfo = ternInfo.pointInfo;
    
    figure(figTern);
    [xSelect, ySelect] = ginput(1);
    indexPoint = findNearestPoint(xSelect, ySelect, ...
        ternInfo.numSelected, pointInfo(:, 1), pointInfo(:, 2));
    
    % find index of other point
    if mod(indexPoint, 2) == 0
        indexPartner = indexPoint - 1;
    else
        indexPartner = indexPoint + 1;
    end
    
    ternInfo.numSelected = ternInfo.numSelected - 2;
    ternInfo.pointInfo = removerows(ternInfo.pointInfo, ...
        [indexPoint, indexPartner]);
    ternInfo.savedPoly = removerows(ternInfo.pointInfo, ...
        [indexPoint, indexPartner]);
    
    figTern.UserData = ternInfo;
    
    plotTernData(ternHandles, specHandles, ECHandles);
    
    set(ternHandles.buttonDelete, 'Callback', ...
        {@callbackButtonDeleteSelection, ternHandles, specHandles, ECHandles});
end

