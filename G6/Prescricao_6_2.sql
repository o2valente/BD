--Problema 6.2)
--5.3)

--a)
SELECT DISTINCT nome,numPresc FROM PRESCRICAO.prescricao AS presc RIGHT OUTER JOIN PRESCRICAO.paciente AS pac ON pac.numUtente=presc.numUtente WHERE numPresc is NULL;

--b)
SELECT especialidade, count(numPresc) as num FROM PRESCRICAO.Medico as med JOIN PRESCRICAO.Prescricao as presc ON med.numSNS=presc.numMedico GROUP BY especialidade;

--c)
SELECT DISTINCT farm.nome,count(presc.numPresc) as num FROM PRESCRICAO.Prescricao AS presc JOIN PRESCRICAO.Farmacia AS farm ON presc.farmacia=farm.nome WHERE presc.farmacia IS NOT NULL GROUP BY farm.nome;

--d)
SELECT farmaco.nome,farmaco.numRegFarm,pcf.numPresc FROM PRESCRICAO.PrescricaoContemFarmacos AS pcf RIGHT OUTER JOIN PRESCRICAO.Farmaco as farmaco ON farmaco.nome=pcf.nomeFarmaco WHERE farmaco.numRegFarm = 906 AND pcf.numPresc is NULL;

--e)
SELECT P.farmacia,pcf.numRegFarm,count(P.farmacia) as num
FROM ((SELECT DISTINCT presc.numPresc, presc.farmacia FROM PRESCRICAO.Prescricao as presc WHERE presc.farmacia IS NOT NULL) as P JOIN PRESCRICAO.PrescricaoContemFarmacos AS pcf ON P.numPresc=pcf.numPresc)
GROUP BY P.farmacia,pcf.numRegFarm

--f)

