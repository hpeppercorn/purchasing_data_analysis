
T1 = rmmissing(readtable('purchasing_order.csv')); % table of data minus the entries that have no rating

return_Y = T1(cell2mat(T1.Return)=='Y',:); % all entries in the table where the item was returned
customers_returned = return_Y.Customer_ID; % all unique customer ids corresponding to the previous table entries

ind1 = find(ismember(T1.Customer_ID, customers_returned)); % index array for all the entries in the full table for customers who returned at least one item

h = T1.Rating(ind1); % the ratings for all customers who returned at least one item

p = cell2mat(T1.Return(ind1))=='Y'; % logical array where 1 is an entry with a returned item, 0 otherwise

