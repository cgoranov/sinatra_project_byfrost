require './config/environment'

use Rack::MethodOverride
use UsersController
use PurchaseOrdersController
use VendorsController
use BudgetsController
run ApplicationController