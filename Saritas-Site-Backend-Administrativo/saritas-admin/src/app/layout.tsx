import type { Metadata } from "next";
import "./globals.css";
export const metadata: Metadata = { title: "Saritas | Malharia e Bordados", description: "Uniformes profissionais, malharia e bordados personalizados." };
export default function RootLayout({children}:{children:React.ReactNode}){return <html lang="pt-BR"><body>{children}</body></html>}
