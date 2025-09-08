CREATE TABLE #jerarquia(
  Evento VARCHAR(20), 
  Jerarquia INT 
)

Insert INTO #jerarquia
-- Specify the destination columns
(Evento,Jerarquia)
-- Insert the appropriate values for track, album and track length
VALUES
  ('ROBO', 1),
  ('ROBO PARCIAL',2),
  ('DAÑOS',3),
  ('CRISTALES',4)


