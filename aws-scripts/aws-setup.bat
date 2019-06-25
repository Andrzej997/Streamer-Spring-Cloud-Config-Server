
FOR /F "tokens=*" %g IN ('aws ecr get-login --region eu-west-1 --no-include-email') do (SET DOCK_VAR=%g)
SET DOCK_VAR_R=%DOCK_VAR:https://=%
%DOCK_VAR_R%
