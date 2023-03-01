function [Aw, Ap] = createUserInputPlots(t,Nd_start,Nd_end)
% CREATEUSERINPUTPLOTS
% This function creates a figure with two subplots plot that takes in user input.
% Left click axis to set control points for curve. Right click to exit edit mode.

button = 0;

xw = [0, t];
yw = [0, 1];

xp = [0, t];
yp = [Nd_start, Nd_end];

% bezier settings
n = 2;
div = 50; 
P = [xw;yw];

figure('Position',[400 200 1000 400])
tiledlayout(1,2);

% Create tiled layout
ax1 = nexttile;
plot(xw, yw, 'Color', "#D95319")
title(ax1, "Maximum pulse width \omega_{max} over time")
xlabel(ax1, "Time [s]")
ylabel(ax1, "\omega_{max} [% of mean spacing between pulses]")
axis([0 t yw(1) yw(end)])
axis manual

ax2 = nexttile;
plot(xp,yp,'Color', "#D95319")
title(ax2, "Pulse density \rho over time")
xlabel(ax2, "Time [s]")
ylabel(ax2, "\rho [pulse/s]")
axis([0 t yp(end) yp(1)])
axis manual

while button~=3
    % calculate Bezier curves for current control points
    count = 1;
    for u = linspace(0,1,div)
        sum = [0 0]';
        for i = 1:n
            B = nchoosek(n,i-1)*(u^(i-1))*((1-u)^(n-i+1)); %B is the Bernstein polynomial value
            sum = sum + B*P(:,i);
        end
        B = nchoosek(n,n)*(u^(n));
        sum = sum + B*P(:,n);
        Aw(:,count) = sum;  %the matrix containing the points of curve as column vectors. 
        count = count+1;    % count is the index of the points on the curve.
    end

    hold on
    %plot Bezier characteristic polygon control points
    plot(xw,yw,'*')     
    %plot Bezier characteristic polygon
    line(P(1,:),P(2,:),'Color',"#EDB120",'LineStyle','--');
    %plot Bezier polygon
    x_B = Aw(1,:);
    y_B = Aw(2,:);
    plot(x_B,y_B);
    hold off

    % get new control points from user input
    [x0,y0,button] = ginput(1);
    if button~=3
        xw = [xw, x0];
        yw = [yw, y0];
        [xw,I] = sort(xw);
        yw = yw(I);

        % Update Bezier parameters for next loop.
        n = n+1;
        P = [xw;yw];
    end

    % clear axis when redrawing
    cla(ax1)
end
% replot everything after it was cleared
hold on
plot(xw,yw,'*')     
line(P(1,:),P(2,:),'Color',"#EDB120",'LineStyle','--');
x_B = Aw(1,:);
y_B = Aw(2,:);
plot(x_B,y_B);
hold off

button = 0;
n = 2;
div = 50; 
P = [xp;yp];
while button~=3
    % calculate Bezier curves for current control points
    count = 1;
    for u = linspace(0,1,div)
        sum = [0 0]';
        for i = 1:n
            B = nchoosek(n,i-1)*(u^(i-1))*((1-u)^(n-i+1)); %B is the Bernstein polynomial value
            sum = sum + B*P(:,i);
        end
        B = nchoosek(n,n)*(u^(n));
        sum = sum + B*P(:,n);
        Ap(:,count) = sum;  %the matrix containing the points of curve as column vectors. 
        count = count+1;    % count is the index of the points on the curve.
    end

    hold on
    %plot Bezier characteristic polygon control points
    plot(xp,yp,'*')     
    %plot Bezier characteristic polygon
    line(P(1,:),P(2,:),'Color',"#EDB120",'LineStyle','--');
    %plot Bezier polygon
    x_B = Ap(1,:);
    y_B = Ap(2,:);
    plot(x_B,y_B);
    hold off

    % get new control points from user input
    if button~=3
        [x0,y0,button] = ginput(1);
        xp = [xp, x0];
        yp = [yp, y0];
        [xp,I] = sort(xp);
        yp = yp(I);
        
        % Update Bezier parameters for next loop.
        n = n+1;
        P = [xp;yp];
    end
    % clear axis when redrawing
    cla(ax2)
end
hold on
plot(xp,yp,'*')     
line(P(1,:),P(2,:),'Color',"#EDB120",'LineStyle','--');
x_B = Ap(1,:);
y_B = Ap(2,:);
plot(x_B,y_B);
hold off

end
