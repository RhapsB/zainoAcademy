from django.db import models

class TipoUsuario(models.Model):
    Tus_id = models.AutoField(primary_key=True) # Cambiado a AutoField
    TusTiposUsuario = models.CharField(max_length=30) # Cambiado a CharField

    class Meta:
        db_table = 'TipoUsuario'
    def _str_(self):
        return self.TusTiposUsuario

class Usuario(models.Model): 
    Us_id = models.AutoField(primary_key=True)
    Us_nombre = models.CharField(max_length=30)
    Us_contraseña = models.CharField(max_length=30)
    fecha_registro = models.DateField(auto_now_add=True)
    documento = models.CharField(max_length=30)
    genero = models.CharField(max_length=30)
    correo = models.EmailField(unique=True)
    TipoUsuario = models.ForeignKey(TipoUsuario, on_delete=models.CASCADE) 

    class Meta:
        db_table = 'usuario'
    def _str_(self):
        return self.Us_nombre

class Curso(models.Model):  
    Cur_id = models.AutoField(primary_key=True)  
    Cur_nombre = models.CharField(max_length=100) 

    class Meta:
        db_table = 'curso'
    def _str_(self):  
        return self.Cur_nombre

class Estudiantes(models.Model):
    Est_id = models.AutoField(primary_key=True) 
    Est_direccion = models.CharField(max_length=100)
    Est_añoAcademico = models.CharField(max_length=30)
    Est_tipoJornada = models.CharField(max_length=30)
    Est_enfermedad = models.CharField(max_length=30)
    Est_eps = models.CharField(max_length=30)
    Est_colegioAnterior = models.CharField(max_length=30)
    Usuario_us = models.ForeignKey(Usuario, on_delete=models.CASCADE) 

    class Meta:
        db_table = 'estudiantes'
    def _str_(self):
        return str(self.Est_id)

class Estudiante_Curso(models.Model):  
    Est_Cur_id = models.AutoField(primary_key=True)  
    Est = models.ForeignKey(Estudiantes, on_delete=models.CASCADE)
    Cur = models.ForeignKey(Curso, on_delete=models.CASCADE)

    class Meta:
        db_table = 'Estudiante_Curso'
    def _str_(self):  
        return str(self.Est_Cur_id)

class Acudiente(models.Model):
    Acu_id = models.AutoField(primary_key=True)
    Usuario_Us = models.ForeignKey(Usuario, on_delete=models.CASCADE)  
    Estudiantes_Est = models.ForeignKey(Estudiantes,on_delete=models.CASCADE)  
    class Meta:
        db_table = 'acudiente'
    def _str_(self):
        return self.Usuario_us_id.Us_nombre

class Directivos(models.Model):
    Dir_id = models.AutoField(primary_key=True) 
    Dir_cargo = models.CharField(max_length=50)
    Dir_telefono = models.CharField(max_length=30)
    Us = models.ForeignKey(Usuario, on_delete=models.CASCADE) 

    class Meta:
        db_table = 'directivos'
    def _str_(self):
        return self.Dir_cargo

class Matricula(models.Model):
    Mat_id = models.AutoField(primary_key=True) 
    Mat_nivel = models.CharField(max_length=50)
    Mat_fecha = models.DateField()
    Mat_estado = models.CharField(max_length=30)
    Mat_metodo_pago = models.CharField(max_length=30)
    Mat_comprobante = models.FileField(upload_to='matricula/', null=True, blank=True)
    Mat_valor = models.CharField(max_length=30)
    Mat_fecha_pago = models.DateField()
    Estudiantes_Est = models.ForeignKey(Estudiantes,on_delete=models.CASCADE)
    Directivos_Dir = models.ForeignKey(Directivos, on_delete=models.CASCADE)

    class Meta:
        db_table = 'matricula'
    def _str_(self):
        return str(self.Mat_id)

class Profesores(models.Model):
    Pro_id = models.AutoField(primary_key=True)
    Us = models.ForeignKey(Usuario, on_delete=models.CASCADE)  

    class Meta:
        db_table = 'profesores'
    def _str_(self):
        return str(self.Pro_id)



class Periodo(models.Model):
    Per_id = models.AutoField(primary_key=True) 
    Per_nombre = models.CharField(max_length=30) 

    class Meta:
        db_table = 'periodo'
    def __str__(self):
        return self.Per_nombre


class Materia(models.Model):
    Mtr_id = models.AutoField(primary_key=True)
    Mtr_nombre = models.CharField(max_length=100)

    class Meta:
        db_table = 'materia'
    def _str_(self):
        return self.Mtr_nombre

class Boletin(models.Model):
    Bol_id = models.AutoField(primary_key=True)
    Pro = models.ForeignKey(Profesores, on_delete=models.CASCADE)  
    Per = models.ForeignKey(Periodo, on_delete=models.CASCADE) 
    Cur = models.ForeignKey(Curso, on_delete=models.CASCADE) 
    Mtr = models.ForeignKey(Materia, on_delete=models.CASCADE) 

    class Meta:
        db_table = 'boletin'
    def _str_(self):
        return str(self.Bol_id)

class Estado_Actividad(models.Model):
    Esta_Actividad_id = models.AutoField(primary_key=True)
    Esta_Actividad_Estado = models.CharField(max_length=30)

    class Meta:
        db_table = 'estado_actividad'
    def _str_(self):
        return self.Esta_Actividad_Estado

class Actividad(models.Model):
    Act_id = models.AutoField(primary_key=True)
    Act_nombre = models.CharField(max_length=30)
    Act_descripcion = models.TextField()
    Act_fechaLimite = models.DateField()
    Act_comentario = models.CharField(max_length=100)
    Act_Archivo_Profesor = models.FileField(upload_to='archivos/profesores/', null=True, blank=True)
    Esta_Actividad = models.ForeignKey(Estado_Actividad, on_delete=models.CASCADE)
    Bol = models.ForeignKey(Boletin, on_delete=models.CASCADE)

    class Meta:
        db_table = 'actividad'

    def _str_(self):
        return self.Act_nombre

class Actividad_Entrega(models.Model):
    Act_Archivo_Estudiante = models.FileField(upload_to='archivos/estudiantes/')
    Act_fecha_entrega = models.DateField(auto_now_add=True)
    Act_calificacion = models.FloatField(null=True, blank=True)
    Act = models.ForeignKey('Actividad', on_delete=models.CASCADE)
    Est = models.ForeignKey('Estudiantes', on_delete=models.CASCADE)

    class Meta:
        db_table = 'actividad_entrega'
        unique_together = ('Act', 'Est')
    def _str_(self):
        return f"{self.Act} - {self.Est}"

class MaterialApoyo(models.Model):
    Mate_id = models.AutoField(primary_key=True)
    Mate_descripcion = models.CharField(max_length=100)
    Mate_titulo = models.CharField(max_length=100)
    Bol = models.ForeignKey(Boletin, on_delete=models.CASCADE)
    Mate_archivo = models.FileField(upload_to='materiales_apoyo/', null=True, blank=True) 

    class Meta:
        db_table = 'material_de_apoyo'

    def _str_(self):
        return self.Mate_titulo


class Estado_Asistencia(models.Model):
    Esta_Asistencia_id = models.AutoField(primary_key=True)
    Esta_Asistencia_Estado = models.CharField(max_length=30)

    class Meta:
        db_table = 'estado_asistencia'
    def _str_(self):
        return self.Esta_Asistencia_Estado


class Asistencia(models.Model):
    Ast_id = models.AutoField(primary_key=True)
    Ast_fecha = models.DateField()
    Esta_Asistencia = models.ForeignKey(Estado_Asistencia,on_delete=models.CASCADE)
    Est_Cur = models.ForeignKey(Estudiante_Curso,on_delete=models.CASCADE)

    class Meta:
        db_table = 'asistencia'
    def _str_(self):
        return str(self.Asis_id)