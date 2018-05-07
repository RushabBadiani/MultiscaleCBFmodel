function Plot_Flow(xns,yns,zns,CCn,QQ,pns)
    whitebg([.1 .1 .1])
    axis equal
    axis on
    hold on
    grid on
    
    Nn = length(xns);
    
    % Plot the links, color-coded by flow rate
    cmap = colormap(hot(20));
    cmin = log(min(QQ(QQ>0)));
    cmax = log(max(QQ(QQ>0)));
    for i=1:Nn
        for j=1:Nn
            if CCn(i,j)>0 && QQ(i,j)>=0
                if QQ(i,j)==0
                    cind = 1;
                else
                    cind = round(19*(log(QQ(i,j))-cmin)/(cmax-cmin)) + 1;
                end
                plot3([zns(i),zns(j)],[xns(i),xns(j)],[yns(i),yns(j)],'-','LineWidth',1,'Color',cmap(cind,:))
            end
        end
    end
    

    xlabel('x');
    ylabel('y');
    zlabel('z');
    set(gca,'Zdir','reverse','Xdir','reverse')
    view([-30 10])

end