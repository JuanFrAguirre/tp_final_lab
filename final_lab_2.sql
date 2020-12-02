----------------
----------------
-- 1W1 - 111830
-- Aguirre, Juan Francisco
----------------
----------------

----------------
-- 1er Ejercicio - subconsulta en el where

-- se pide mostrar el id, apellido y nombre de los responsables quienes hayan provisto mantenimiento a las maquinas percutoras (busque por 'maquina_percutora') el dia de hoy, cuya duracion sea menor a 5 dias,
-- pero solo para aquellos responsables que hayan registrado mantenimientos con duracion superior a 10 dias en los ultimos 2 meses. Muestre obviamente la fecha y la duracion. Rotule y ordene por id de responsable de manera descendente

select
	r.id_responsable 'ID responsable',
	r.apellido + space(2) + r.nombre 'Apellido y nombre',
	m.fecha Fecha,
	m.duracion 'Tiempo en mantenimiento'
from
	mantenimientos m join responsables r on m.id_responsable = r.id_responsable
	join maquinas mq on mq.id_maquina = m.id_maquina
	join tipos_maq tmq on tmq.id_tipo_maq = mq.id_tipo_maq
where
	tmq.tipo_maq like '%m_quina_percutora%'
	and
	m.fecha = getdate()
	and
	m.duracion < 5
	and
	r.id_responsable in (
						select
						-- aqui va r1.id_responsable >>typo<<
							r.id_responsable 
						from
							mantenimientos m1 join responsables r1 on m1.id_responsable = r1.id_responsable 
						where  
							datediff(day, m1.fecha, getdate()) <= 60  
							and  
							m.duracion > 10
						)
order by
	1 desc


----------------
-- 2do Ejercicio - vista

create view vw_cant_cost_mant
as
select
	count(*) 'Cantidad mantenimientos',
	format(sum(m.costo_total), 'C', 'en-us') 'Costo total',
	avg(m.duracion) 'Promedio duracion',
	year(m.fecha) 'Año',
	m.id_maquina 'ID maquina'
from
	mantenimientos m join maquinas mq on mq.id_maquina = m.id_maquina
group by
	year(m.fecha), m.id_maquina -- mq.id_tipo_maq
having
	avg(m.costo_total) > (
						select 
							avg(m1.costo_total) 
						from 
							mantenimientos m1 join maquinas mq1 on mq1.id_maquina = m1.id_maquina 
						where 
							mq1.id_tipo_maq = mq.id_tipo_maq
						)

-- consulta a la vista
select
	[ID maquina],
	mc.marca Marca,
	[Costo total]
from
	vw_cant_cost_mant join maquinas mq on [ID maquina] = mq.id_maquina
	join marcas mc on mc.id_marca = mq.id_marca
-- group by   --esto no va
--	 [ID maquina], mc.marca, [Costo total]
having --aqui seria un where
	[Promedio duracion] > (
							select 
								avg(m1.duracion) 
							from 
								mantenimientos m1
							)
	
----------------

