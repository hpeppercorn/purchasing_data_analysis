
T2 = readtable('purchasing_order.csv'); % table of all data

return_Y = T2(cell2mat(T2.Return)=='Y',:); % all entries in the table where the item was returned
[customers_returned, ind2] = unique(return_Y.Customer_ID,'stable'); % all unique customer ids corresponding to the previous table entries, and the index array such that return_Y.Customer_ID(ind1,:) == customers_returned 
    
ind3 = find(ismember(T2.Customer_ID, customers_returned)); % index array for all the entries in the full table for customers who returned at least one item
ind4 = intersect(find(cell2mat(T2.Return)=='N'), ind3); % same as ind3 but without any entries where the item was returned
total_sums = grpstats(T2(ind4,:),'Customer_ID','sum','DataVars',{'Product_Value'}); % table of the ind4 enties of T2, grouped by customer and calculating the sum of all purchases (not returned) for each customer


customers_returned_data = return_Y(ind2, :); % entries in T2 for the first return each customer made

sum_values = zeros(height(customers_returned_data),1); % preallocation for the array of sums of purchase values

for i = 1 : height(customers_returned_data)
   
    % for each customer this finds the date they first returned an item and finds the sum of all (non returned) purchases made after that point, adds it to an array of all such sums 
    
    dat = datenum(customers_returned_data{i,1});
    cust = customers_returned_data{i,2};
    values = T2((T2.Customer_ID==cust)&((datenum(T2.Date)>dat))&(cell2mat(T2.Return)=='N'),:);
    sum_values(i,1) = sum(values{:,4});
    
end

after_return_sums = sortrows(table(customers_returned,sum_values),1); % creates a table (sorted by increasing customer ID) of all customers and the sum of all their (non-returned) purchases, after an initial return

ratios = after_return_sums{:,2} ./ total_sums{:,3}; % array of probabilities that each customer will make another purchase

likelihood = mean(ratios) % mean of probabilities for each customer


