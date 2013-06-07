function plotData(X, y)
% crta pozicije pozitivnih(+) i negativnih (o) primjera u 2D mrezi
% mozemo vidjeti za svaka dva featurea u kakvom su odnosu pozitivni i
% negativni

    figure; hold on;

    pos = find(y==1); % izdvoji pozitivne 
    neg = find(y == 0); % izdvoji negativne
    % crtaj pozitivne
    plot(X(pos, 1), X(pos, 2), 'k+','LineWidth', 2, ...
        'MarkerSize', 10);
    %crtaj negativne
    plot(X(neg, 1), X(neg, 2), 'ko', 'MarkerFaceColor', 'y', ...
        'MarkerSize', 10);


    hold off;

end
