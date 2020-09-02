function m = isMonotonic(f)
    i1 = 1;
    i2 = 2;
    for i = 1:254
        if(f(i1) == f(i2))
            i1 = i1 + 1;
            i2 = i2 + 1;
        else
            break
        end
    end
        
    if(f(i1) > f(i2))
        incr = false;
    else
        incr = true;
    end
    
    m = 1;
    for i = 1:(length(f)-1)
        if(~incr && (f(i)<f(i+1)))
            m = 0;
            break;
        end
        if(incr && (f(i)>f(i+1)))
            m = 0;
            break;
        end
    end

end