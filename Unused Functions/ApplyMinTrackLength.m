function tracks_out = ApplyMinTrackLength(tracks_in,min_track_length)
    a = unique(tracks_in(:,4)); 
    b = []; 
    for i = 1:length(a)
        c = sum(tracks_in(:,4) == a(i)); 
        if (c < min_track_length)
            b = [b,a(i)];  %#ok<AGROW>
        end
    end
    tracks_out = tracks_in; 
    for i = 1:length(b)
        tracks_out(tracks_out(:,4) == b(i),:) = []; 
    end
end