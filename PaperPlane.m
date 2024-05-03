%	Example 1.3-1 Paper Airplane Flight Path
%	Copyright 2005 by Robert Stengel
%	August 23, 2005

	global CL CD S m g rho	
	S		=	0.017;			% Reference Area, m^2
	AR		=	0.86;			% Wing Aspect Ratio
	e		=	0.9;			% Oswald Efficiency Factor;
	m		=	0.003;			% Mass, kg
	g		=	9.8;			% Gravitational acceleration, m/s^2
	rho		=	1.225;			% Air density at Sea Level, kg/m^3	
	CLa		=	3.141592 * AR/(1 + sqrt(1 + (AR / 2)^2));
							% Lift-Coefficient Slope, per rad
	CDo		=	0.02;			% Zero-Lift Drag Coefficient
	epsilon	=	1 / (3.141592 * e * AR);% Induced Drag Factor	
	CL		=	sqrt(CDo / epsilon);	% CL for Maximum Lift/Drag Ratio
	CD		=	CDo + epsilon * CL^2;	% Corresponding CD
	LDmax	=	CL / CD;			% Maximum Lift/Drag Ratio
	Gam		=	-atan(1 / LDmax);	% Corresponding Flight Path Angle, rad
	V		=	sqrt(2 * m * g /(rho * S * (CL * cos(Gam) - CD * sin(Gam))));
							% Corresponding Velocity, m/s
	Alpha	=	CL / CLa;			% Corresponding Angle of Attack, rad
	
%	a) Equilibrium Glide at Maximum Lift/Drag Ratio
	H		=	2;			% Initial Height, m
	R		=	0;			% Initial Range, m
	to		=	0;			% Initial Time, sec
	tf		=	6;			% Final Time, sec
	tspan	=	[to tf];
	xo		=	[V;Gam;H;R];
	[ta,xa]	=	ode23('EqMotion',tspan,xo);
    %InitVelocity
    xo		=	[2;Gam;H;R];
	[ta_low,xa_lowv]	=	ode23('EqMotion',tspan,xo);
    xo		=	[3.55;Gam;H;R];
	[ta_nom,xa_nomv]	=	ode23('EqMotion',tspan,xo);
    xo		=	[7.55;Gam;H;R];
	[ta_high,xa_highv]	=	ode23('EqMotion',tspan,xo);
    %Gamma
    xo		=	[V;-0.5;H;R];
	[ta_lowf,xa_lowf]	=	ode23('EqMotion',tspan,xo);
    xo		=	[V;-0.18;H;R];
	[ta_nomf,xa_nomf]	=	ode23('EqMotion',tspan,xo);
    xo		=	[V;0.4;H;R];
	[ta_highf,xa_highf]	=	ode23('EqMotion',tspan,xo);
	
%	b) Oscillating Glide due to Zero Initial Flight Path Angle
	xo		=	[V;0;H;R];
	[tb,xb]	=	ode23('EqMotion',tspan,xo);

%	c) Effect of Increased Initial Velocity
	xo		=	[1.5*V;0;H;R];
	[tc,xc]	=	ode23('EqMotion',tspan,xo);

%	d) Effect of Further Increase in Initial Velocity
	xo		=	[3*V;0;H;R];
	[td,xd]	=	ode23('EqMotion',tspan,xo);
	
	
%Variation of height and initial velocity.    
    % figure
    % subplot(2,1,1)
	% plot(xa_lowv(:,4),xa_lowv(:,3),'red',xa_nomv(:,4),xa_nomv(:,3), 'black',xa_highv(:,4),xa_highv(:,3),'green')
	% xlabel('Range, m'), ylabel('Height, m'), grid
    % legend('Low V = 2','Nominal V = 3.55','High V = 7.55')
    % title('Initial Velocity Analysis')
    % subplot(2,1,2)
    % plot(xa_lowf(:,4),xa_lowf(:,3),'red',xa_nomf(:,4),xa_nomf(:,3),'black',xa_highf(:,4),xa_highf(:,3),'green')
	% xlabel('Range, m'), ylabel('Height, m'), grid
    % title('Flight Path Angle Analysis')
    % legend('Low \gamma = -0.5','Nominal \gamma = -0.18','High \gamma = 0.4')


%100 Varying initial conditions. Need to find way
figure
colormap parula
hold on
N = 100;
V_max = 7.55;
V_min = 0;
Gam_max = 0.4;
Gam_min = -.5;

    conc_time = zeroes(1,N);
    conc_range = zeroes(1,N);
    conc_height = zeroes(1,N);

 for i = 1:N
    
    V_rand = V_min + (V_max-V_min)*rand(1);
    Gam_rand = Gam_min + (Gam_max-Gam_min)*rand(1);

    xo_rand = [V_rand;Gam_rand;H;R];
    [te,xe]	=	ode23('EqMotion',tspan,xo_rand);
    plot(xe(:,4),xe(:,3))

    conc_time(i) = 1;
    conc_range(i) = 1;
    conc_height(i) = 1;
 end
xlabel('Range, m'), ylabel('Height, m'), grid
title('Varying Initial Velocity and Flight Path Angle')

	% figure
	% plot(xa(:,4),xa(:,3),xb(:,4),xb(:,3),xc(:,4),xc(:,3),xd(:,4),xd(:,3))
	% xlabel('Range, m'), ylabel('Height, m'), grid
    % 
	% figure
	% subplot(2,2,1)
	% plot(ta,xa(:,1),tb,xb(:,1),tc,xc(:,1),td,xd(:,1))
	% xlabel('Time, s'), ylabel('Velocity, m/s'), grid
	% subplot(2,2,2)
	% plot(ta,xa(:,2),tb,xb(:,2),tc,xc(:,2),td,xd(:,2))
	% xlabel('Time, s'), ylabel('Flight Path Angle, rad'), grid
	% subplot(2,2,3)
	% plot(ta,xa(:,3),tb,xb(:,3),tc,xc(:,3),td,xd(:,3))
	% xlabel('Time, s'), ylabel('Altitude, m'), grid
	% subplot(2,2,4)
	% plot(ta,xa(:,4),tb,xb(:,4),tc,xc(:,4),td,xd(:,4))
	% xlabel('Time, s'), ylabel('Range, m'), grid
