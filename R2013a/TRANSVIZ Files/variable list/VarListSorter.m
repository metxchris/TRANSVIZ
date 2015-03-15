function VarListSorter(tableH,data,tag,button)

switch button
    case 'VarId'
        % need to convert VarID column to numeric data to sort.
        % other cases use a standard sorting procedure.
        varID=str2double(data(:,1));
        if eval(tag)==1
            [~,sIdx]=sortrows(varID,-1);
            set(tableH,'data',data(sIdx,:));
            set(tableH,'tag','-1');
        else
            [~,sIdx]=sortrows(varID,1);
            set(tableH,'data',data(sIdx,:));
            set(tableH,'tag','1');
        end
    case 'Name'
        if eval(tag)==2
            set(tableH,'data',sortrows(data,-2))
            set(tableH,'tag','-2')
        else
            set(tableH,'data',sortrows(data,2))
            set(tableH,'tag','2')
        end
    case 'Description'
        if eval(tag)==3
            set(tableH,'data',sortrows(data,-3))
            set(tableH,'tag','-3')
        else
            set(tableH,'data',sortrows(data,3))
            set(tableH,'tag','3')
        end
    case 'Units'
        if eval(tag)==4
            set(tableH,'data',sortrows(data,-4))
            set(tableH,'tag','-4')
        else
            set(tableH,'data',sortrows(data,4))
            set(tableH,'tag','4')
        end
    case 'Dimensions'
        if eval(tag)==5
            set(tableH,'data',sortrows(data,-5))
            set(tableH,'tag','-5')
        else
            set(tableH,'data',sortrows(data,5))
            set(tableH,'tag','5')
        end
    case 'Size'
        if eval(tag)==6
            set(tableH,'data',sortrows(data,-6))
            set(tableH,'tag','-6')
        else
            set(tableH,'data',sortrows(data,6))
            set(tableH,'tag','6')
        end
    case 'Fct IDs'
        if eval(tag)==4
            set(tableH,'data',sortrows(data,-4))
            set(tableH,'tag','-4')
        else
            set(tableH,'data',sortrows(data,4))
            set(tableH,'tag','4')
        end
end

end