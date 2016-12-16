
function [hard, f, its] = decoder_ms_cf1_gen(llr,I,cf)

	assert(isa(llr,'double'));
	assert(all(size(llr) == [1 2048]));
	assert(isa(I,'double'));
	assert(all(size(I) == [1 1]));
	assert(isa(cf,'double'));
	assert(all(size(cf) == [1 1]));

	ld = coder.load( 'decoder_new.mat', 'N');

	N = uint16(ld.N);

	f = uint8(1);
	Ii = uint32(I);

	%f1 = false(1,512);
	f2 = false(1,512);
	%f3 = false(1,512);
	f3 = f2;

	%fs1 = 0;
	fs2 = uint16(0);
	fs3 = uint16(0);

	its = int32(0);

	llr_ = zeros(1,1024);

	%hard=zeros(I,1024);
	hard = false(1,1024);

	%c1 = zeros(1,512);
	c2 = zeros(1,512);
	%c3 = zeros(1,512);
	c3 = c2;
		
	var = zeros(15,512);
	%che = zeros(15,512);
	che = zeros(15,512);
	che_ = zeros(15,512);

    %v = zeros(15,512);
    %s = zeros(15,512);
    %v = var;
    %s = var;

    for i=1:512
        var(4,N(4,i))=llr(i);
        var(10,N(10,i))=llr(i);
        
        var(5,N(5,i))=llr(i+512);
        var(11,N(11,i))=llr(i+512);
        var(12,N(12,i))=llr(i+512);
        
        var(1,N(1,i))=llr(i+1024);
        
        var(6,N(6,i))=llr(i+1536);
        var(13,N(13,i))=llr(i+1536);
        var(14,N(14,i))=llr(i+1536);
    end
 
    v = abs(var);
    s = sign(var);
    
    it = int32(0);

    while ( (it<=Ii) & (f>0) )
        it = it+1;

        for i=1:512
            %che(1,i) = s(2,i)*s(3,i)*min(v(2,i),v(3,i));
            che(2,i) = s(1,i)*s(3,i)*min(v(1,i),v(3,i));
            che(3,i) = s(2,i)*s(1,i)*min(v(2,i),v(1,i));
            %c1(i) = s(1,i)*s(2,i)*s(3,i); 
            
            che(4,i) = s(5,i)*s(6,i)*s(7,i)*s(8,i)*s(9,i)*min([v(5,i),v(6,i),v(7,i),v(8,i),v(9,i)]);
            che(5,i) = s(4,i)*s(6,i)*s(7,i)*s(8,i)*s(9,i)*min([v(4,i),v(6,i),v(7,i),v(8,i),v(9,i)]);
            che(6,i) = s(5,i)*s(4,i)*s(7,i)*s(8,i)*s(9,i)*min([v(5,i),v(4,i),v(7,i),v(8,i),v(9,i)]);
            che(7,i) = s(5,i)*s(6,i)*s(4,i)*s(8,i)*s(9,i)*min([v(5,i),v(6,i),v(4,i),v(8,i),v(9,i)]);
            che(8,i) = s(5,i)*s(6,i)*s(7,i)*s(4,i)*s(9,i)*min([v(5,i),v(6,i),v(7,i),v(4,i),v(9,i)]);
            che(9,i) = s(5,i)*s(6,i)*s(7,i)*s(8,i)*s(4,i)*min([v(5,i),v(6,i),v(7,i),v(8,i),v(4,i)]);
            c2(i) = s(4,i)*s(5,i)*s(6,i)*s(7,i)*s(8,i)*s(9,i);
            
            che(10,i) = s(11,i)*s(12,i)*s(13,i)*s(14,i)*s(15,i)*min([v(11,i),v(12,i),v(13,i),v(14,i),v(15,i)]);
            che(11,i) = s(10,i)*s(12,i)*s(13,i)*s(14,i)*s(15,i)*min([v(10,i),v(12,i),v(13,i),v(14,i),v(15,i)]);
            che(12,i) = s(11,i)*s(10,i)*s(13,i)*s(14,i)*s(15,i)*min([v(11,i),v(10,i),v(13,i),v(14,i),v(15,i)]);
            che(13,i) = s(11,i)*s(12,i)*s(10,i)*s(14,i)*s(15,i)*min([v(11,i),v(12,i),v(10,i),v(14,i),v(15,i)]);
            che(14,i) = s(11,i)*s(12,i)*s(13,i)*s(10,i)*s(15,i)*min([v(11,i),v(12,i),v(13,i),v(10,i),v(15,i)]);
            che(15,i) = s(11,i)*s(12,i)*s(13,i)*s(14,i)*s(10,i)*min([v(11,i),v(12,i),v(13,i),v(14,i),v(10,i)]);
            c3(i) = s(10,i)*s(11,i)*s(12,i)*s(13,i)*s(14,i)*s(15,i);
        end
        
        %che(1,:) = che(1,:)*cf;
        che_(2:15,:) = che(2:15,:)*cf;
        
        for i=1:512
            var(4,N(4,i))=llr(i)+che_(10,N(10,i));
            var(10,N(10,i))=llr(i)+che_(4,N(4,i));
            
            var(5,N(5,i))=llr(i+512)+che_(11,N(11,i))+che_(12,N(12,i));
            var(11,N(11,i))=llr(i+512)+che_(5,N(5,i))+che_(12,N(12,i));
            var(12,N(12,i))=llr(i+512)+che_(5,N(5,i))+che_(11,N(11,i));
            
            %var(1,N(1,i))=llr(i+1024);
            
            var(6,N(6,i))=llr(i+1536)+che_(13,N(13,i))+che_(14,N(14,i));
            var(13,N(13,i))=llr(i+1536)+che_(14,N(14,i))+che_(6,N(6,i));
            var(14,N(14,i))=llr(i+1536)+che_(13,N(13,i))+che_(6,N(6,i));
            
            var(2,N(2,i))=che_(3,N(3,i))+che_(7,N(7,i))+che_(8,N(8,i))+che_(9,N(9,i))+che_(15,N(15,i));
            var(3,N(3,i))=che_(2,N(2,i))+che_(7,N(7,i))+che_(8,N(8,i))+che_(9,N(9,i))+che_(15,N(15,i));
            var(7,N(7,i))=che_(3,N(3,i))+che_(2,N(2,i))+che_(8,N(8,i))+che_(9,N(9,i))+che_(15,N(15,i));
            var(8,N(8,i))=che_(3,N(3,i))+che_(7,N(7,i))+che_(2,N(2,i))+che_(9,N(9,i))+che_(15,N(15,i));
            var(9,N(9,i))=che_(3,N(3,i))+che_(7,N(7,i))+che_(8,N(8,i))+che_(2,N(2,i))+che_(15,N(15,i));
            var(15,N(15,i))=che_(3,N(3,i))+che_(7,N(7,i))+che_(8,N(8,i))+che_(9,N(9,i))+che_(2,N(2,i));            
        end

		v = abs(var);
		s = sign(var);       
			
		for i=1:512
			llr_(i)=llr(i)+che_(4,N(4,i))+che_(10,N(10,i));
			llr_(i+512)=llr(i+512)+che_(5,N(5,i))+che_(11,N(11,i))+che_(12,N(12,i));
		end

		%f1 = c1 < 1;
		f2 = c2 < 1;
		f3 = c3 < 1;
		
		%fs1 = sum(f1);
		fs2 = sum(f2);
		fs3 = sum(f3);
		
		if (fs2+fs3) == 0;
			f = uint8(0);
		else
			if fs2 == 0
				f = uint8(3);
			else
				if fs3 == 0
					f = uint8(2);
				else
					f = uint8(1);
				end
			end
		end
	   
		if it > 1
			%fc(it-1) = (fs2+fs3);
			%fc2(it-1) = fs2;
			%fc3(it-1) = fs3;      
			its = it-1;    
		end  
			
    end
	
    hard = llr_ < 0;    
    
end