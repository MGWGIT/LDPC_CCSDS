
function [hard, f, its] = decoder_sp_gen(llr,I)

	assert(isa(llr,'double'));
	assert(all(size(llr) == [1 2048]));
	assert(isa(I,'double'));
	assert(all(size(I) == [1 1]));

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

    %v = zeros(15,512);
    %s = zeros(15,512);
    %v = var;
    %s = var;

	%	variable node initialization
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

    while ( (it<=Ii) & (f>0) )	%	until max iterations or no errors reached
        it = it+1;
		
		%	check node update
	for i=1:512
            %che(1,i) = s(2,i)*s(3,i)*min(v(2,i),v(3,i));
            che(2,i) = 2*atanh(tanh(var(1,i)/2)*tanh(var(3,i)/2));
            che(3,i) = 2*atanh(tanh(var(2,i)/2)*tanh(var(1,i)/2));
            %c1(i) = s(1,i)*s(2,i)*s(3,i); 
            
            che(4,i) = 2*atanh(tanh(var(5,i)/2)*tanh(var(6,i)/2)*tanh(var(7,i)/2)*tanh(var(8,i)/2)*tanh(var(9,i)/2));
            che(5,i) = 2*atanh(tanh(var(4,i)/2)*tanh(var(6,i)/2)*tanh(var(7,i)/2)*tanh(var(8,i)/2)*tanh(var(9,i)/2));
            che(6,i) = 2*atanh(tanh(var(5,i)/2)*tanh(var(4,i)/2)*tanh(var(7,i)/2)*tanh(var(8,i)/2)*tanh(var(9,i)/2));
            che(7,i) = 2*atanh(tanh(var(5,i)/2)*tanh(var(6,i)/2)*tanh(var(4,i)/2)*tanh(var(8,i)/2)*tanh(var(9,i)/2));
            che(8,i) = 2*atanh(tanh(var(5,i)/2)*tanh(var(6,i)/2)*tanh(var(7,i)/2)*tanh(var(4,i)/2)*tanh(var(9,i)/2));
            che(9,i) = 2*atanh(tanh(var(5,i)/2)*tanh(var(6,i)/2)*tanh(var(7,i)/2)*tanh(var(8,i)/2)*tanh(var(4,i)/2));
            c2(i) = s(4,i)*s(5,i)*s(6,i)*s(7,i)*s(8,i)*s(9,i);
            
            che(10,i) = 2*atanh(tanh(var(11,i)/2)*tanh(var(12,i)/2)*tanh(var(13,i)/2)*tanh(var(14,i)/2)*tanh(var(15,i)/2));
            che(11,i) = 2*atanh(tanh(var(10,i)/2)*tanh(var(12,i)/2)*tanh(var(13,i)/2)*tanh(var(14,i)/2)*tanh(var(15,i)/2));
            che(12,i) = 2*atanh(tanh(var(11,i)/2)*tanh(var(10,i)/2)*tanh(var(13,i)/2)*tanh(var(14,i)/2)*tanh(var(15,i)/2));
            che(13,i) = 2*atanh(tanh(var(11,i)/2)*tanh(var(12,i)/2)*tanh(var(10,i)/2)*tanh(var(14,i)/2)*tanh(var(15,i)/2));
            che(14,i) = 2*atanh(tanh(var(11,i)/2)*tanh(var(12,i)/2)*tanh(var(13,i)/2)*tanh(var(10,i)/2)*tanh(var(15,i)/2));
            che(15,i) = 2*atanh(tanh(var(11,i)/2)*tanh(var(12,i)/2)*tanh(var(13,i)/2)*tanh(var(14,i)/2)*tanh(var(10,i)/2));
            c3(i) = s(10,i)*s(11,i)*s(12,i)*s(13,i)*s(14,i)*s(15,i);
        end
		
        %	variable node update
        for i=1:512
            var(4,N(4,i))=llr(i)+che(10,N(10,i));
            var(10,N(10,i))=llr(i)+che(4,N(4,i));
            
            var(5,N(5,i))=llr(i+512)+che(11,N(11,i))+che(12,N(12,i));
            var(11,N(11,i))=llr(i+512)+che(5,N(5,i))+che(12,N(12,i));
            var(12,N(12,i))=llr(i+512)+che(5,N(5,i))+che(11,N(11,i));
            
            %var(1,N(1,i))=llr(i+1024);
            
            var(6,N(6,i))=llr(i+1536)+che(13,N(13,i))+che(14,N(14,i));
            var(13,N(13,i))=llr(i+1536)+che(14,N(14,i))+che(6,N(6,i));
            var(14,N(14,i))=llr(i+1536)+che(13,N(13,i))+che(6,N(6,i));
            
            var(2,N(2,i))=che(3,N(3,i))+che(7,N(7,i))+che(8,N(8,i))+che(9,N(9,i))+che(15,N(15,i));
            var(3,N(3,i))=che(2,N(2,i))+che(7,N(7,i))+che(8,N(8,i))+che(9,N(9,i))+che(15,N(15,i));
            var(7,N(7,i))=che(3,N(3,i))+che(2,N(2,i))+che(8,N(8,i))+che(9,N(9,i))+che(15,N(15,i));
            var(8,N(8,i))=che(3,N(3,i))+che(7,N(7,i))+che(2,N(2,i))+che(9,N(9,i))+che(15,N(15,i));
            var(9,N(9,i))=che(3,N(3,i))+che(7,N(7,i))+che(8,N(8,i))+che(2,N(2,i))+che(15,N(15,i));
            var(15,N(15,i))=che(3,N(3,i))+che(7,N(7,i))+che(8,N(8,i))+che(9,N(9,i))+che(2,N(2,i));            
        end

		v = abs(var);
		s = sign(var);       

		%	parity check by 2nd and 3rd groups of nodes
		%f1 = c1 < 1;
		f2 = c2 < 1;
		f3 = c3 < 1;
		
		%fs1 = sum(f1);
		fs2 = sum(f2);	%	parity check errors in 1-512
		fs3 = sum(f3);	%	parity check errors in 513-1024
		
		if (fs2+fs3) == 0;
			f = uint8(0);			%	no errors
		else
			if fs2 == 0
				f = uint8(3);		%	errors in 3rd group
			else
				if fs3 == 0
					f = uint8(2);	%	errors in 2nd group
				else
					f = uint8(1);	%	errors in 2nd and 3rd groups
				end
			end
		end
	   
		if it > 1
			%fc(it-1) = (fs2+fs3);
			%fc2(it-1) = fs2;
			%fc3(it-1) = fs3;      
			its = it-1;	%	last iteration number   
		end  
			
    end
	
	%	output llr computation		
	for i=1:512
		llr_(i)=llr(i)+che(4,N(4,i))+che(10,N(10,i));
		llr_(i+512)=llr(i+512)+che(5,N(5,i))+che(11,N(11,i))+che(12,N(12,i));
	end
		
    hard = llr_ < 0;    
    
end