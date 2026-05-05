import express, { Request, Response } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import helmet from 'helmet'; // Agregamos Helmet para mejorar la seguridad de los headers HTTP




dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());
app.use(helmet()); // Usamos Helmet para proteger contra vulnerabilidades comunes

// Importamos los middlewares de seguridad
import { checkAuth, authorizeRole, checkAdoptionBenefit } from './middlewares/auth';

// --- RUTAS DE LA API ---

// Ruta pública de prueba
app.get('/api/health', (req: Request, res: Response) => {
    res.json({ status: 'OK', message: 'API Clínica Segura funcionando correctamente' });
});

// Ruta protegida solo con Autenticación (Cualquier usuario logueado)
app.get('/api/perfil', checkAuth, (req: Request, res: Response) => {
    res.json({ message: 'Perfil recuperado', user: (req as any).user });
});

// Ruta RBAC: Solo Admin y Veterinarios pueden ver el historial
app.get('/api/historial-medico', checkAuth, authorizeRole(['admin', 'veterinario']), (req: Request, res: Response) => {
    res.json({ data: "Historiales médicos confidenciales de las mascotas" });
});

// Ruta ABAC: Solo clientes que han adoptado ven las ofertas exclusivas
app.get('/api/tienda/ofertas-exclusivas', checkAuth, authorizeRole(['clientela']), checkAdoptionBenefit, (req: Request, res: Response) => {
    res.json({ data: "¡Felicidades! Tienes un 50% de descuento en la tienda por haber adoptado." });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🚀 Servidor corriendo en http://localhost:${PORT}`);
});