function [t_fismat, t_error, stepsize, c_fismat, c_error] = manfis(trnData, in_fismat, t_opt, d_opt, chk_data, mf_in_type, mf_out_type, method)

if(~exist('method','var'))
    method=1;
end

% Change the following to set default train options.
default_t_opt = [10;  0; 0.01; 0.9;  1.1; 1]; 

% Change the following to set default display options.
default_d_opt = [1; 1;  1;  1]; 

% Change the following to set default MF type and numbers
default_inmf_type = mf_in_type;    
default_outmf_type = mf_out_type;
default_mf_number = 2;

% method = opts.OptimizationMethod;
if nargin <= 4, chk_data = [];                  end
if nargin <= 3, d_opt = default_d_opt;          end
if nargin <= 2, t_opt = default_t_opt;          end
if nargin <= 1, in_fismat = default_mf_number;  end

% If fismat, d_opt or t_opt are nan's or []'s, replace them with default settings
if isempty(in_fismat)
   in_fismat = default_mf_number;
elseif ~isstruct(in_fismat) & length(in_fismat) == 1 & isnan(in_fismat),
   in_fismat = default_mf_number;
end 
if isempty(t_opt),
    t_opt = default_t_opt;
elseif length(t_opt) == 1 & isnan(t_opt),
    t_opt = default_t_opt;
end
if isempty(d_opt),
    d_opt = default_d_opt;
elseif length(d_opt) == 1 & isnan(d_opt),
    d_opt = default_d_opt;
end
if isempty(method)
   method = 1;
elseif length(method) == 1 & isnan(method),
   method = 1;
elseif method>1 |method<0
   method =1;
end 
% If d_opt or t_opt is not fully specified, pad it with default values. 
if length(t_opt) < 6,
    tmp = default_t_opt;
    tmp(1:length(t_opt)) = t_opt;
    t_opt = tmp;
end
if length(d_opt) < 5,
    tmp = default_d_opt;
    tmp(1:length(d_opt)) = d_opt;
    d_opt = tmp;
end

% If entries of d_opt or t_opt are nan's, replace them with default settings
nan_index = find(isnan(d_opt)==1);
d_opt(nan_index) = default_d_opt(nan_index);
nan_index = find(isnan(t_opt)==1);
t_opt(nan_index) = default_t_opt(nan_index);

% Generate FIS matrix if necessary
% in_fismat is a single number or a vector 
if class(in_fismat) ~= 'struct',
    MFStart = tic;
    in_fismat = genfis1(trnData, in_fismat, default_inmf_type, default_outmf_type);
    sprintf('Generation of %s Membership Function Completed in %3.4f Seconds', mf_in_type, toc(MFStart))
end

% if t_opt(end)==1 % adding bias if user has specified
%     in_fismat.bias = 0;
% end
    

% More input/output argument checking
if nargin <= 4 & nargout > 3, error('Too many output arguments!');  end
if length(t_opt) ~= 6,        error('Wrong length of t_opt!');      end
if length(d_opt) ~= 4,        error('Wrong length of d_opt!');      end

max_iRange = max([trnData;chk_data],[],1);
min_iRange = min([trnData;chk_data],[],1);
%Set input and output ranges to match training & checking data
for iInput = 1:length(in_fismat.input)
   in_fismat.input(iInput).range = [min_iRange(1,iInput), ...
      max_iRange(1,iInput)];
end
for iOutput = 1:length(in_fismat.output)
   in_fismat.output(iOutput).range = [min_iRange(1,iInput+iOutput), ...
      max_iRange(1,iInput+iOutput)];
end
%Make sure input MF's cover complete range
for iInput = 1:length(in_fismat.input)
   [oLow,oHigh,MFBounds] = localFindMFOrder(in_fismat.input(iInput).mf);
   %First ensure range limits are covered
   if all(isfinite(MFBounds(:,1))) & ...
         in_fismat.input(iInput).mf(oLow(1)).params(1) > min_iRange(1,iInput)
      %Lower limit
      in_fismat.input(iInput).mf(oLow(1)).params(1) = (1-sign(min_iRange(1,iInput))*0.1)...
         *min_iRange(1,iInput)-eps;
   end
   if all(isfinite(MFBounds(:,2))) & ...
         in_fismat.input(iInput).mf(oHigh(end)).params(end) < max_iRange(1,iInput)
      %Upper limit
      in_fismat.input(iInput).mf(oHigh(end)).params(end) = (1+sign(min_iRange(1,iInput))*0.1)...
         *max_iRange(1,iInput)+eps;
   end
   %Now ensure that whole data range is covered
   if ~any(all(~isfinite(MFBounds),2))
      %Don't have any set with +- inf bounds
      for iMF = 1:numel(oLow)-1
         %Loop through sets and assign corner points to overlap
         if in_fismat.input(iInput).mf(oLow(iMF)).params(end) < ...
               in_fismat.input(iInput).mf(oLow(iMF+1)).params(1)
            in_fismat.input(iInput).mf(oLow(iMF)).params(end) = (1+sign(min_iRange(1,iInput))*0.01)...
               *in_fismat.input(iInput).mf(oLow(iMF+1)).params(1) + eps;
         end
      end
   end   
end

% Start the real thing!
if nargout == 0,
    anfismex(trnData, in_fismat, t_opt, d_opt, chk_data, method);
    return
elseif nargout == 1,
    [t_fismat] = anfismex(trnData, in_fismat, t_opt, d_opt, chk_data, method);
elseif nargout == 2,
    [t_fismat, t_error] = anfismex(trnData, in_fismat, t_opt, d_opt, chk_data, method);
elseif nargout == 3,
    [t_fismat, t_error, stepsize] = anfismex(trnData, in_fismat, t_opt, d_opt, chk_data, method);
elseif nargout == 4,
    [t_fismat, t_error, stepsize, c_fismat] = anfismex(trnData, in_fismat, t_opt, d_opt, chk_data, method);
elseif nargout == 5,
    [t_fismat, t_error, stepsize, c_fismat, c_error] = anfismex(trnData, in_fismat, t_opt, d_opt, chk_data, method);
end        
if isfield(t_fismat, 'bias')
    t_fismat = rmfield(t_fismat, 'bias');
end
if nargout>3 && isfield(c_fismat, 'bias')
    c_fismat = rmfield(c_fismat,'bias');
end


%--------------------------------------------------------------------------
function [orderLow,orderHigh,MFBounds] = localFindMFOrder(MF)
%Function to find the order in which the mf's cover the range
%orderLow is the order of the lower mf 'corners'
%orderHigh is the order of the higher mf 'corners'

MFBounds = zeros(numel(MF),2);
for iMF = 1:numel(MF)
   switch lower(MF(iMF).type)
      case {'trimf','trapmf','pimf'}
         MFBounds(iMF,:) = [MF(iMF).params(1), MF(iMF).params(end)];
      case 'smf'
         MFBounds(iMF,:) = [MF(iMF).params(1), inf];
      case 'zmf'
         MFBounds(iMF,:) = [-inf, MF(iMF).params(end)];
      otherwise
         MFBounds(iMF,:) = [-inf, inf];
   end         
end

[junk,orderLow] = sort(MFBounds(:,1),1,'ascend');
if nargout >= 2
   [junk,orderHigh] = sort(MFBounds(:,2),1,'ascend');
end
