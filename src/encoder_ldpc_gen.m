function code = coder_ldpc_comp(x)
    assert(isa(x,'logical'));
    assert(all(size(x) == [1 1024]));
    ld = coder.load('coder.mat','G');
    code = mod(x*ld.G,2)>0;
end

