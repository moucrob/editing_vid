base = '/home/exs/Videos/';   % Assumed to be existing
cd(base);
lists ={["1","2","3"], ["a","b"], ["q","r"]};
%build the cartesian product of elements of lists:
cartprod = cell(size(lists));
[cartprod{:}] = ndgrid(lists{:});
%pass the cartesian product to fullfile to build the paths
allpaths = fullfile(cartprod{:});
%now iterate over all the paths
for pidx = 1:numel(allpaths)
  if ~exist(allpaths(pidx))
    mkdir(allpaths(pidx));  %will create all inexistant directories in the path
  end
end
