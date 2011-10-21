function[a] = next(self,num)
% next -- Returns the next combination
%
% a = next( [[ num = 1 ]] )
%
%     Returns the next num combinations as a (num x self.N) array. Returns the
%     empty array when all combinations are exhausted.

if nargin < 2
  num = 1;
end

a = zeros([num self.N]);

row = 1;
while row <= num;
  if isempty(self.current_coordinate)
    a(row:end,:) = [];
    return
  end

  % Extract data
  a(row,:) = self.ghost_array(sub2ind(self.ghost_array_size, self.current_coordinate, (1:self.N)'));

  % Update coordinates
  self.next_coordinate = find(self.current_coordinate < self.vector_lengths, 1, 'last');

  if isempty(self.next_coordinate)
    self.current_coordinate = [];
  else
    self.current_coordinate(self.next_coordinate) = self.current_coordinate(self.next_coordinate) + 1;
    self.current_coordinate(self.next_coordinate+1:end) = 1;
    self.next_coordinate = self.first_nontrivial_index;
  end

  row = row + 1;
end
