require './config/environment'

use Rack::MethodOverride
use PurchaseOrdersController
use VendorsController
use BudgetsController
run ApplicationController