class ComplainsController < ApplicationController

    before_action :authenticate_user!
    before_action :set_complain, only: [:show, :edit, :update, :destroy]
    before_action :verify_password_change
    autocomplete :complain, :contravertion
    autocomplete :complain, :crime
     helper_method :getColor
    def index
        if user_signed_in?
          @patrol_units = Array.new
            @role_current_user = current_user.role

          if      @role_current_user==1
              
            PatrolUnit.all.each do |comp|
              if comp.name == nil
                comp.name=""
              end
              @patrol_units << [comp.code + ' ' + comp.name,comp.id]
            end

                if params[:search]
                  @complains = Complain.search(params[:search]).order("created_at DESC")
                else
                 @complains=Complain.where("created_at <?",DateTime.now ).paginate(:page => params[:page], :per_page => 10)
                 end
          elsif  @role_current_user==2
            if params[:search]
              @complains = Complain.search(params[:search]).order("created_at DESC")
            else
               @complains = Complain.where(:user_id =>current_user.id)
             end
          end
        end
    end
    # GET /complains/1
    # GET /complains/1.json
    def show
      @observationsAux = params[:observationsAux]
      @caseReportAux = params[:caseReportAux]
      @complain = Complain.find(params[:id])
      @complainant = Complainant.where(:complain_id => @complain.id).first
    end
    def caseReport

   @complain = Complain.find(params[:id])
   @complain.completeDate = Date.today
   if @message.save
    redirect_to myHomeMessages_path, :flash => { :success => "." }
   else
    redirect_to myHomeMessages_path, :flash => { :error => "." }
   end

    end
    def index_oficial

      
       
    end
    def autocomplete
      @patrolUnits = PatrolUnit.all.map do |patrol_unit|
        {
          name: patrol_unit.name
        }
      end

  render json: @patrolUnits
end
    def getColor(prob)
        if prob>=0.0 && prob<=0.30
       return "#1B592B"
       end
        if  prob>=0.31 && prob<=0.49
          return "#0431B4"
        end
      if prob>=0.50 && prob<=0.79
         return "#E8F853"
        end
        if prob>=0.80 && prob<=0.100
              
          return"#FFFFFF"  
        end
end

    def index2
    
    @dateStart =  params[:startdate]
    puts params[:startdate]
    @aux=@dateStart
    @aux2=@dateStart
    
    if @dateStart!=nil
       @aux=@aux.split(' ')[1..-1].join(' ')
       puts "asd"
      puts  @aux2.split("/")[0]
        puts "asdmmm"
        puts  @aux2.split("/")[1]
        puts"cdff"
        puts  (@aux2.split("/")[2]).partition(" ").first
 puts"cdffjjjjjjjjj"
    puts @aux
    @aux=@aux.chomp(' AM')
    puts "fdsffsd"
    puts @aux
 @aux= DateTime.new( (@aux2.split("/")[2]).partition(" ").first.to_i,(@aux2.split("/")[0]).to_i,(@aux2.split("/")[1]).to_i,  (@aux.split(":")[0]).to_i, ( @aux.split(":")[1]).to_i, 0,0)
   #@aux= Time.parse(@dateStart).strftime("%d/%m/%y").change({ hour: ( @aux.split(":")[0]).to_i, min:( @aux.split(":")[1]).to_i})
 #puts DateTime.new(@aux2.split("/")[0],@aux2.split("/")[1],(@aux2.split("/")[2]).partition(" ").first,@aux.split(":")[0]).to_i, ( @aux.split(":")[1]).to_i, 0,0) 
  
puts @aux
 
    end
    @dateEnd=params[:enddate]
    @turn=params[:turnHour]
   @totalTodayDays = Complain.group("date_trunc('day',complains.created_at)").where('EXTRACT(DOW FROM complains.created_at) = ? and complains.created_at BETWEEN ? AND ? ', @aux.wday , @dateBegin,@dateFinal).count.size
  
    @aux1 = Complain.joins(:crime).last
    @dateStartToTime =Time.now
    @probOfDay=1
    @dateBegin = Complain.first.created_at
    @dateFinal =Complain.last.created_at
    @totalDaysDB = Complain.group("date_trunc('day',complains.created_at)").where('  complains.created_at BETWEEN ? AND ? ', @dateBegin,@dateFinal).count.size
    @thereIsRecordsInDB = true
    @turnHour=""
    if @turn!=nil
      puts "entra"
      puts case @turn
      when '8:00-16:00'
        @turnHour="morning"
        puts"sad"
        puts@turnHour
      when '16:00-00:00'
         @turnHour="afternoon"
          puts"sad2"
        puts@turnHour
      else
         @turnHour="night"
          puts"sad3"
        puts@turnHour
      end
    end

    if @dateStart!=nil && @dateStart!=""
    if ((@aux.to_i>=@dateBegin.to_i )&&(@aux.to_i <=@dateFinal.to_i) ) 
       @dateStartToTime=  Time.parse(@dateStart)
    elsif (@aux.to_i<@dateBegin.to_i)
         @thereIsRecordsInDB = false
    elsif  (@aux.to_i>=Time.now.to_i)
           @dateStartToTime=  @aux
           puts "nnnn"
           puts @totalTodayDays
           puts"nnnnnnn"
           puts @totalDaysDB
           @probOfDay=@totalTodayDays/@totalDaysDB.to_f
     end 
     end 
    
         # @dateStart = DateTime.new params[:startdate]["{:ampm=>true}(1i)"].to_i,params[:startdate] ["{:ampm=>true}(2i)"].to_i, params[:startdate]["{:ampm=>true}(3i)"].to_i, params[:startdate]["{:ampm=>true}(4i)"].to_i,  params[:startdate]["{:ampm=>true}(5i)"].to_i
          #@dateEnd = DateTime.new params[:enddate]["{:ampm=>true}(1i)"].to_i, params[:enddate]["{:ampm=>true}(2i)"].to_i, params[:enddate]["{:ampm=>true}(3i)"].to_i, params[:enddate]["{:ampm=>true}(4i)"].to_i, params[:enddate]["{:ampm=>true}(5i)"].to_i

         #@dateS=@dateStart.strftime("%d/%m/%Y") 
        # @dateE=@dateEnd.strftime("%d/%m/%Y") 
        # @hourE= @dateEnd.strftime("%H:%M")
         #@hourS =@dateStart.strftime("%H:%M")
         # @aux= Complain.joins(:crime).group("date_trunc('day',complains.created_at)").where('EXTRACT(DOW FROM complains.created_at) = ? and complains.created_at BETWEEN ? AND ? ', 5, '2014-11-09 09:00','2014-11-17 09:00').count
   
 
    puts @totalDaysDB
    @totalHoursDB = 24 * @totalDaysDB
   @dateBegin = Complain.first.created_at
         @dateFinal =Complain.last.created_at
    @totalTodayDays = Complain.group("date_trunc('day',complains.created_at)").where('EXTRACT(DOW FROM complains.created_at) = ? and complains.created_at BETWEEN ? AND ? ', @dateStartToTime.wday , @dateBegin,@dateFinal).count.size
    if @dateStart!=nil && @dateStart!=""
     if ( @aux.to_i>Time.now.to_i)
      @probOfDay= @totalTodayDays.to_f/@totalDaysDB
     end 
    end
       @totalHoursTodayDays = @totalTodayDays *8

       @totalCrimes = Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).count
       @totalContravertions = Contravertion.includes(:complains).count
        @totalHoursDB = @totalDaysDB*24
        @totalCrimesDayToday = Complain.where( ' EXTRACT(DOW FROM complains.created_at) = ? and complains.created_at BETWEEN ? AND ? ',@dateStartToTime.wday , @dateBegin,@dateFinal).includes(:crimes).count 
        @totalCrimesDayTodayBetween8to16 =  Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( ' EXTRACT(DOW FROM complains.created_at) = ?  and complains.created_at::time BETWEEN ? AND ? and complains.created_at BETWEEN ? AND ? ', @dateStartToTime.wday , '08:00:00','15:59:59' , @dateBegin,@dateFinal).count
        @totalCrimesDayTodayBetween16to0 =  Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( 'EXTRACT(DOW FROM complains.created_at) = ?  and   complains.created_at::time BETWEEN ? AND ? and complains.created_at BETWEEN ? AND ? ', @dateStartToTime.wday , '16:00:00','23:59:59' , @dateBegin,@dateFinal).count
            puts "total"
        @totalCrimesDayTodayBetween0to8 =  Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( ' EXTRACT(DOW FROM complains.created_at) = ?  and  complains.created_at::time BETWEEN ? AND ? and complains.created_at BETWEEN ? AND ? ', @dateStartToTime.wday , '00:00:00','07:59:59'  , @dateBegin,@dateFinal).count
        @totalCrimesZoneNorEste=  Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( ' complains.zone = ? ', 'Nor Este').count 
        @totalContravertionsZoneNorEste=  Complain.includes(:contravertions).where( '  complains.zone = ? ', 'Nor Este').count 
        @probDay = @totalTodayDays/@totalDaysDB.to_f

        @probDayCrime=@totalCrimesDayToday.to_f/(@totalCrimes+@totalContravertions)

        @probCrime =( @totalCrimesDayTodayBetween8to16/(@totalDaysDB+@totalHoursDB.to_f)) + (@totalCrimesDayTodayBetween16to0/(@totalDaysDB+@totalHoursDB.to_f))+(  @totalCrimesDayTodayBetween0to8/(@totalDaysDB+@totalHoursDB.to_f) ) 
    #NOR ESTE INI
        @probZoneNE =( @totalCrimesZoneNorEste.to_f+@totalContravertionsZoneNorEste)/ (@totalCrimes+@totalContravertions)
        @probDayAndHourRange8to16 =( @totalCrimesDayTodayBetween8to16/(@totalHoursDB+@totalDaysDB.to_f))/@probCrime
        @probDayAndHourRange16to0 =( @totalCrimesDayTodayBetween16to0 /(@totalHoursDB+@totalDaysDB.to_f))/@probCrime
        @probDayAndHourRange0to8 =( @totalCrimesDayTodayBetween0to8/(@totalHoursDB+@totalDaysDB.to_f))/@probCrime
        
        @probNE8to16 =( @probOfDay*@probDayCrime.to_f *  @probDayAndHourRange8to16.to_f ) / @probZoneNE.to_f
        @probNE16to0 =( @probOfDay*@probDayCrime.to_f *  @probDayAndHourRange16to0.to_f ) / @probZoneNE.to_f
       
        @probNE0to8 =( @probOfDay*@probDayCrime.to_f *  @probDayAndHourRange0to8.to_f ) / @probZoneNE.to_f
     
      #FIN NOR ESTE
      #ini no oeste
      @totalCrimesZoneNorOeste=   Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( ' complains.zone = ? ', 'Nor Oeste').count 
      @totalContravertionsZoneNorOeste=   Complain.includes(:contravertions).where( ' complains.zone = ? ', 'Nor Oeste').count 
      @probZoneNO= ( @totalCrimesZoneNorOeste.to_f+@totalContravertionsZoneNorOeste)/ (@totalCrimes+@totalContravertions)
      @probNO8to16 =(  @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange8to16.to_f ) / @probZoneNO.to_f
      @probNO16to0 =(  @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange16to0.to_f ) / @probZoneNO.to_f
      @probNO16to0=@probNO16to0.round(1)
      @probNO0to8 =(  @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange0to8.to_f ) / @probZoneNO.to_f
       @probNO0to8 = @probNO0to8.round(1)
      #fin nor oeste
      #CENTRAL NORTE
      @totalCrimesZoneCentralNorte=   Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( '  complains.zone = ? ', 'Nor Oeste').count 
      @totalContravertionsZoneCentralNorte=  Complain.includes(:contravertions).where( '  complains.zone = ? ', 'Central Norte').count 
      @probZoneCN= ( @totalCrimesZoneCentralNorte.to_f+@totalContravertionsZoneCentralNorte)/ (@totalCrimes+@totalContravertions)
      @probCN8to16 =( @probOfDay*  @probDayCrime.to_f *  @probDayAndHourRange8to16.to_f ) / @probZoneCN.to_f
      @probCN16to0 =( @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange16to0.to_f ) / @probZoneCN.to_f
      @probCN0to8 =(  @probOfDay*@probDayCrime.to_f *  @probDayAndHourRange0to8.to_f ) / @probZoneCN.to_f
      # FIN CN
      #ini cs
       @totalCrimesZoneCentralSud=  Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( ' complains.zone = ? ', 'Nor Oeste').count 
      @totalContravertionsZoneCentralSud=  Complain.includes(:contravertions).where( '  complains.zone = ? ', 'Central Sud').count 
      @probZoneCS= ( @totalCrimesZoneCentralSud.to_f+@totalContravertionsZoneCentralSud)/ (@totalCrimes+@totalContravertions)
      @probCS8to16 =(  @probOfDay*@probDayCrime.to_f *  @probDayAndHourRange8to16.to_f ) / @probZoneCS.to_f
      @probCS16to0 =( @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange16to0.to_f ) / @probZoneCS.to_f
      @probCS0to8 =(  @probOfDay*@probDayCrime.to_f *  @probDayAndHourRange0to8.to_f ) / @probZoneCS.to_f
     #fin cs
     #ini sud este
      @totalCrimesZoneSudEste=   Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where(   'complains.zone = ? ', 'Nor Oeste').count 
      @totalContravertionsZoneSudEste=  Complain.includes(:contravertions).where( ' complains.zone = ? ', 'Sud Este').count 
      @probZoneSE= ( @totalCrimesZoneSudEste.to_f+@totalContravertionsZoneSudEste)/ (@totalCrimes+@totalContravertions)
      @probSE8to16 =( @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange8to16.to_f ) / @probZoneSE.to_f
      @probSE16to0 =( @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange16to0.to_f ) / @probZoneSE.to_f
      @probSE0to8 =(  @probOfDay*@probDayCrime.to_f *  @probDayAndHourRange0to8.to_f ) / @probZoneSE.to_f
     
    #fin sud este
     #ini sud oeste
     @totalCrimesZoneSudEste=   Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( ' complains.zone = ? ', 'Nor Oeste').count 
      @totalContravertionsZoneSudEste=  Complain.includes(:contravertions).where( '  complains.zone = ? ', 'Sud Oeste').count 
      @probZoneSO= ( @totalCrimesZoneSudEste.to_f+@totalContravertionsZoneSudEste)/ (@totalCrimes+@totalContravertions)
      @probSO8to16 =(  @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange8to16.to_f ) / @probZoneSO.to_f
      @probSO16to0 =(  @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange16to0.to_f ) / @probZoneSO.to_f
      @probSO0to8 =(   @probOfDay*@probDayCrime.to_f *  @probDayAndHourRange0to8.to_f ) / @probZoneSO.to_f
      
    #fin sdoeste
  

        @listProb =Array.new()
        @listProb <<(@probNO8to16*100).round(2)
        @listProb <<(@probNE8to16*100).round(2)
        @listProb <<(@probCN8to16*100).round(2)
        @listProb <<(@probCS8to16*100).round(2)
        @listProb <<(@probSO8to16*100).round(2)
        @listProb <<(@probSE8to16*100).round(2)
      
        @listProb <<(@probNO16to0*100).round(2)
        @listProb <<(@probNE16to0*100).round(2)
        @listProb <<(@probCN16to0*100).round(2)
        @listProb <<(@probCS16to0*100).round(2)
        @listProb <<(@probSO16to0*100).round(2)
        @listProb <<(@probSE16to0*100).round(2)
       
        @listProb <<(@probNO0to8*100).round(2) 
        @listProb <<(@probNE0to8*100).round(2)
        @listProb <<(@probCN0to8*100).round(2)            
        @listProb <<(@probCS0to8*100).round(2)  
        @listProb <<(@probSO0to8*100).round(2)
        @listProb <<(@probSE0to8*100).round(2)

         @averageCrimesPerDay=@totalCrimes/@totalDaysDB.to_f 
        
        @norE= ComplainsAuxiliar.where( "delito  is NOT NULL  and 'complains_auxiliars.ZonaUrbana'  like ? ",'Nor Este').count
        puts "nore"
        puts @norE
        @norO = ComplainsAuxiliar.where( "delito  is NOT NULL AND  'complains_auxiliars.ZonaUrbana'  like ? ",'Nor Oeste').count
        @centralN = ComplainsAuxiliar.where( "delito  is NOT NULL AND 'complains_auxiliars.ZonaUrbana'  like ?","Central Norte").count
     
         @centralS= ComplainsAuxiliar.where( "complains_auxiliars.delito  is NOT NULL AND  'complains_auxiliars.ZonaUrbana'  like ? ","Central Sud").count
         @surE= ComplainsAuxiliar.where( "delito  is NOT NULL AND  'complains_auxiliars.ZonaUrbana'  like ? ","Sud Este").count
         @surO = ComplainsAuxiliar.where( "delito  is NOT NULL AND  'complains_auxiliars.ZonaUrbana'  like ? ","Sud Oeste").count

        # @errorNE =   ((( @probNE * (1-  @probNE )) / @averageCrimesPerDay)**0.5)*1.96       
        # @espNE= @averageCrimesPerDay *  @probNE 
         #@inINE =  (@probNE.to_f-@errorNE ) *100
         #@inSNE =  (@probNE.to_f+@errorNE ) *100
   

         @probNO= @norO.to_f/ @totalCrimes.to_f
         puts @nor0.to_f.to_s + "nor|"   
         puts  @totalCrime 
         puts   @probN0.to_s    + "pron"

         @errorNO =   ((( @probNO * (1-  @probNO )) / @averageCrimesPerDay)**0.5)*1.96
         @espNO= @averageCrimesPerDay *  @probNO 
         @inINO =  (@probNO.to_f-@errorNO) *100
         @inSNO =  (@probNO.to_f+@errorNO ) *100
         @probN0=@probN0.to_f*100

         @probCN= @centralN.to_f/ @totalCrime.to_f 
         @errorCN =   ((( @probCN * (1-  @probCN )) / @averageCrimesPerDay)**0.5)*1.96  
         @espCN= @averageCrimesPerDay *  @probCN 
         @inICN =  (@probCN.to_f-@errorCN ) *100
         @inSCN =  (@probCN.to_f+@errorCN ) *100
         @probCN=@probCN.to_f*100

         @probCS= @centralS.to_f/ @totalCrime.to_f 
         @errorCS =   ((( @probCS * (1-  @probCS )) / @averageCrimesPerDay)**0.5)*1.96
        
         @espCS= @averageCrimesPerDay *  @probCS 
         @inICS =  (@probCS.to_f-@errorCS ) *100
         @inSCS =  (@probCS.to_f+@errorCS ) *100
         @probCS=@probCS.to_f*100
 
        @probSE= @surE.to_f/ @totalCrime.to_f 
         @errorSE =   ((( @probSE * (1-  @probSE )) / @averageCrimesPerDay)**0.5)*1.96       
         @espSE= @averageCrimesPerDay *  @probSE.to_f 
         @inISE =  (@probSE.to_f-@errorSE ) *100
         @inSSE =  (@probSE.to_f+@errorSE ) *100
         @probSE=@probSE.to_f*100

         @probSO= @surO.to_f/ @totalCrime.to_f          
         @errorSO =   ((( @probSO * (1-  @probSO )) / @averageCrimesPerDay)**0.5)*1.96
         @espSO= @averageCrimesPerDay *  @probSO 
         @inISO =  (@probSO.to_f-@errorSO ) *100
         @inSSO =  (@probSO.to_f+@errorSO ) *100
         @probSO=@probSO.to_f*100
        #  end
    end
    def index3
     #@differenceHour=(((strftime('%s', '2011-11-10 11:46') - strftime('%s', '2011-11-09 09:00')) % (60 * 60 * 24)) / (60 * 60) 

          ComplainsAuxiliar.all.where("id >= 9999999").each do |comp|
     # if @complainAux.contravencion=="380.3" || @complainAux.contravencion=="380.2" || @complainAux.contravencion=="380.4" || @complainAux.contravencion="380.10"
         
       @complainAux = comp
       if @complainAux.hora!=nil
       @complain = Complain.new

       puts "faasdaas"
        puts @complainAux.fecha

       puts "faasdaas"
        puts @complainAux.hora

      
      
      # @complain.created_at=  @complainAux.fecha.change({ hour: @complainAux.hora.hour, min: @complainAux.hora.min, sec: @complainAux.hora.sec })
      @complain.created_at=  Time.parse(@complainAux.fecha).change({ hour:   Time.at((@complainAux.hora.split(':').map { |a| a.to_i }.inject(0) { |a, b| a * 60 + b})).hour, min: Time.at((@complainAux.hora.split(':').map { |a| a.to_i }.inject(0) { |a, b| a * 60 + b})).min, sec: Time.at((@complainAux.hora.split(':').map { |a| a.to_i }.inject(0) { |a, b| a * 60 + b})).sec })
    
        puts "@complain.created_at"
        puts @complain.created_at

       @complain.complainNumber = @complainAux.numeroDenuncia
      if @complainAux.lugarDenuncia=="AREA URBANA"
          @complain.ruralArea=false
       else
          @complain.ruralArea=true
        end  
       if @complainAux.nombreOperador==""
          @complain.operatorNameFromMigrateData="DE OFICIO"
       else
          @complain.operatorNameFromMigrateData=@complainAux.nombreOperador
       
       end
        if@complainAux.nroTelefono!=nil && ( @complainAux.nroTelefono <= "79999999" && @complainAux.nroTelefono>"60000000" )
          if  ( @complainAux.nroTelefono.is_a? Integer)|| @complainAux.nroTelefono!=0
           @complain.telephoneNumberComplainantFromMigrateData = @complainAux.nroTelefono
        end
      end
        @complain.complainantNameFromMigrateData=@complainAux.denunciante
        #  @complain.crime_id= Crime.where(:code =>(@complainAux.delito).split[0...2].join(' ')).pluck(:id).first.to_i
      if @complainAux.contravencion!=nil
      if @complainAux.contravencion=='380.3' ||  @complainAux.contravencion=='380.2' || @complainAux.contravencion=='380.4'||@complainAux.contravencion=='380.10'
        @complain.contravertion_id = Contravertion.where(:code =>@complainAux.contravencion).pluck(:id).first.to_i
       puts "adaasdaa11111111"
      puts @complain.contravertion_id 
      else
       @complain.contravertion_id = Contravertion.where(:code =>(@complainAux.contravencion).split[0...2].join(' ')).pluck(:id).first.to_i
      
      puts "adaasdaa"
      puts @complain.contravertion_id 

      end
       end
       if @complainAux.delito!=nil
        @complain.crime_id = Crime.where(:code =>(@complainAux.delito).split[0...2].join(' ')).pluck(:id).first.to_i
       end
       @complain.zone = @complainAux.ZonaUrbana
       @complain.provinceName=@complainAux.zonaRural
       @complain.addressFromMigrateData=@complainAux.direccion
        @complain.description  = @complainAux.descripcionHecho
        if @complainAux.reporteCaso=="POSITIVO"
          @complain.caseReport =true
        else
          @complain.caseReport = false
        end
       
       if @complainAux.unidadAsignada!=nil
        @complain.patrol_unit_id = PatrolUnit.where(:code =>(@complainAux.unidadAsignada.upcase+"\n")).pluck(:id).first.to_i
      if  @complain.patrol_unit_id ==0
        @complain.patrol_unit_id = PatrolUnit.where(:code =>(@complainAux.unidadAsignada.upcase)).pluck(:id).first.to_i
     end
      puts "complain.patrol_unit_id "
     
      puts @complain.patrol_unit_id 
     end.change({ hour:   Time.at((@complainAux.hora.split(':').map { |a| a.to_i }.inject(0) { |a, b| a * 60 + b})).hour, min: Time.at((@complainAux.hora.split(':').map { |a| a.to_i }.inject(0) { |a, b| a * 60 + b})).min, sec: Time.at((@complainAux.hora.split(':').map { |a| a.to_i }.inject(0) { |a, b| a * 60 + b})).sec })
    
      @complain.derivationCase=@complainAux.remisionCaso
      @complain.shortReport =@complainAux.breveInforme
      @complain.protagonists= @complainAux.protagonista
       @complain.save!
     end  
    end
         
    end

    def index_aux
          @dateStartToTime =Time.now
    @dateBegin = Complain.order("complains.created_at ASC").first.created_at
    @dateFinal =Complain.order("complains.created_at ASC").last.created_at
    @totalDaysDB = Complain.group("date_trunc('day',complains.created_at)").where('  complains.created_at BETWEEN ? AND ? ', @dateBegin,@dateFinal).count.size
    
    @totalCrimesDayToday =  Complain.where( 'complains.created_at BETWEEN ? AND ? ' , @dateBegin,@dateBegin).includes(:crimes).count 
    @date =@dateBegin.change({ hour: 0, min: 0, sec: 1 })

    @dateFinal=@date.change({ hour: 23, min: 59, sec: 59 })
     @average8=Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( ' complains.created_at BETWEEN ? AND ? ', @date,@dateFinal).order("complains.created_at ASC").count
     puts "mmmmmmm"
      @totalTodayDays = Complain.group("date_trunc('day',complains.created_at)").where('EXTRACT(DOW FROM complains.created_at) = ? and complains.created_at BETWEEN ? AND ? ', @dateStartToTime.wday , @dateBegin,@dateFinal).count.size
   
     puts "mmmmmmm"
 
 @average4=Complain.where( ' complains.created_at BETWEEN ? AND ? ', @date,@dateFinal).includes(:crimes).count


     @i=999999
    until @i >= @totalDaysDB  do
      @average = Average.new
      @average.name = "delitos"
      @average.created_at=@date

      @average.average= Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( ' complains.created_at BETWEEN ? AND ? ', @date,@dateFinal).count

      puts  @average.average
      #@average.save!
      
      if @i==1
      @average1 = Average.new
      @average1.name = "prob"
      @average1.created_at=@date
      @average1.average= 0 
      #@average1.save!
    else
      @average2 = Average.new
      @average2.name = "prob"
      @average2.created_at=@date
      @avg=  Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( 'complains.created_at BETWEEN ? AND ? ' , @dateBegin,@date).count

      @avg=@avg  /@i.to_f
      @average2.average=@avg.round(2) ;
      #@average2.save!
      end
      @i +=1;
      @date= @date+1.day
      @dateFinal=@dateFinal+1.day



end
@size= Average.all.where( ' name = ? ', 'prob').count 
puts @size
puts "dsf"
    @pro1= Average.all.where( ' name = ? ', 'prob')
puts @pro1 
puts "msmd"
    @pro2= Average.all.where( ' name = ? ', 'delitos')
    puts @pro2 
puts "msd"
    @items = []
    
      @i = 0
puts @size.to_i
    while (@i < @size.to_i-1)
       @subarray = [] 
      if @i==0
        @subarray.push( 'date'.to_json)
        @subarray.push("Bytes from network:Bytes to network".to_json)
        @subarray.push("Bytes".to_json)
        @items.push(@subarray)
      end
     @subarray = [] 
     puts @pro1[@i].created_at.strftime("%d/%m/%y")  
puts "msmdmmm"
    puts @pro2[@i].created_at.strftime("%d/%m/%y")  
puts "msmdmkkkkmm"
     # if @pro1[@i].created_at.strftime("%d/%m/%y") ==@pro2[@i].created_at.strftime("%d/%m/%y")
        puts "sdkfdjkfjk"
      @subarray.push(@pro1[@i].created_at.utc.to_i*1000)
      @subarray.push(@pro1[@i].average)
      @subarray.push(@pro2[@i].average)
     @items.push(@subarray)
    #end
      @i += 1
    end

        
  end

    def new
        if current_user.role==2 ||current_user.role==1
          @complain = Complain.new
          @complainant = Complainant.new
          @crimes = Array.new
          Crime.all.each do |comp|
            @crimes << [comp.code + ' ' + comp.name]
          end
          @contravertions = Array.new
          Contravertion.all.each do |comp|
            @contravertions << [comp.code + ' ' + comp.name]
          end


        else
          redirect_to root_url
        end
  end
   
    def edit
        @complain = Complain.find(params[:id])
        @complainant = Complainant.where(:complain_id => @complain.id).first
     
        if current_user.role==2 ||current_user.role==1
      #  check_box_params[:auxCrime]= @complain.crie.code+ ' ' +@complain.crime.name
          @crimes = Array.new
          Crime.all.each do |comp|
            @crimes << [comp.code + ' ' + comp.name]
          end
          @contravertions = Array.new
          Contravertion.all.each do |comp|
            @contravertions << [comp.code + ' ' + comp.name]
          end
        else
          redirect_to root_url
        end
    end

   

    def create
      @complain = Complain.new(complain_params)
      @complainant = Complainant.new(complainant_params)
      @crimes = Array.new
      @complain.user_id= current_user.id

      Crime.all.each do |comp|
        @crimes << [comp.code + ' ' + comp.name]
      end
      @contravertions = Array.new
      Contravertion.all.each do |comp|
        @contravertions << [comp.code + ' ' + comp.name]
      end

      if check_box_params[:crime]=='1'
        @auxCrime_id = Crime.where(:code =>(params[:auxCrime]).split[0...2].join(' ')).pluck(:id).first.to_i
      end
      if check_box_params[:contravertion]=='1'
        @auxContravertion_id = Contravertion.where(:code =>(params[:auxContravertion]).split[0...2].join(' ')).pluck(:id).first.to_i
      end
      if @auxCrime_id!=0
        @complain.crime_id = @auxCrime_id
      end
      if @auxContravertion_id!=0
          @complain.contravertion_id = @auxContravertion_id
      end

      respond_to do |format|
        if (check_box_params[:crime]=='0'&& check_box_params[:contravertion]=='0')|| ( @auxCrime_id== 0 && @auxContravertion_id==0 ) || (check_box_params[:crime]=='1' && @auxCrime_id == 0)|| (check_box_params[:contravertion]=='1' && @auxContravertion_id == 0)
          flash[:notice] = "Debe registrar un delito o una contraversion correctamente"
          format.html { render :new }
          format.json { render json: @complain.errors, status: :unprocessable_entity }
        end
        if  @complain.valid?
              if !@complainant.valid?
                format.html { render :new}
                format.json { render json: @complainant.errors, status: :unprocessable_entity }
              else
                @complain.save!
                @complainant.complain_id= @complain.id
                @complainant.save!
                flash[:notice] = "Denuncia registrada exitosamente"
                format.html { redirect_to @complain }
                format.json { render :show, status: :created, location: @complain }
              end
        else
           format.html { render :new}
           format.json { render json: @complain.errors, status: :unprocessable_entity }
         end
      end
    end
    def patrol_unit_asign

      @complain = Complain.find(params[:complain][:complain_id])
       @complain.update_attribute(:patrol_unit_id,  params[:complain][:patrol_unit_id])
   if @complain.save!
    redirect_to complains_path, :flash => { :success => "Your message was closed." }
   else
    redirect_to show_path, :flash => { :error => "Error closing message." }
   end
    end

    def update
      if @observationsAux==nil
      @complain = Complain.find(params[:id])
      @complain.observations = params[:observations]
      @complainant = Complainant.where(:complain_id => @complain.id).first
      if @complainant==nil
          @complainant = Complainant.new(complainant_params)
      end
      @crimes = Array.new
      Crime.all.each do |comp|
        @crimes << [comp.code + ' ' + comp.name]
        end
      @contravertions = Array.new
      Contravertion.all.each do |comp|
        @contravertions << [comp.code + ' ' + comp.name]
        end

      if check_box_params[:crime]=='1'
        @auxCrime_id = Crime.where(:code =>(params[:auxCrime]).split[0...2].join(' ')).pluck(:id).first.to_i
        puts Crime.where(:code =>(params[:auxCrime]).split[0...2].join(' ')).pluck(:id).first.to_i
      end
      if check_box_params[:contravertion]=='1'
        @auxContravertion_id = Contravertion.where(:code =>(params[:auxContravertion]).split[0...2].join(' ')).pluck(:id).first.to_i
      end
      if @auxCrime_id!=0
        @complain.crime_id = @auxCrime_id
      end
      if @auxContravertion_id!=0
        @complain.contravertion_id = @auxContravertion_id
      end
    end
      respond_to do |format|
        if ((check_box_params[:crime]=='0'&& check_box_params[:contravertion]=='0')|| ( @auxCrime_id== 0 && @auxContravertion_id==0 ) || (check_box_params[:crime]=='1' && @auxCrime_id == 0)|| (check_box_params[:contravertion]=='1' && @auxContravertion_id == 0))
          flash[:notice] = "Debe registrar un delito o una contraversion correctamente"
          format.html { render :new }
          format.json { render json: @complain.errors, status: :unprocessable_entity }
        end
        if  @complain.valid?
              if !@complainant.valid?
                format.html { render :new}
                format.json { render json: @complainant.errors, status: :unprocessable_entity }
              else
                @complain.update_attributes(complain_params)
                @complain.save!
                @complainant.complain_id= @complain.id
                @complainant.save!
                flash[:notice] = "Denuncia registrada exitosamente UPDATE"
                format.html { redirect_to @complain }
                format.json { render :show, status: :created, location: @complain }
              end
        else
           format.html { render :new}
           format.json { render json: @complain.errors, status: :unprocessable_entity }
         end
      end

  end
 
    def destroy
      @complain.destroy
      respond_to do |format|
        format.html { redirect_to complains_url, notice: 'denuncia eliminado exitosamente.' }
        format.json { head :no_content }
      end
    end

      # Use callbacks to share common setup or constraints between actions.
      def set_complain
        @complain = Complain.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def complain_params
        params.require(:complain).permit(:protagonists, :description, :zone, :latitude, :longitude, :crime_id, :observations)
      end
      def check_box_params
        params.require(:complain).permit( :contravertion,:crime, :crime_checkbox , :contravertion_checkbox, :crimeAux,  :crime_id,:contravertion_id,:auxCrime, :auxContravertion, :observations,:patrol_unit, :turnHour ,:zoneCrime)
      end
      def complainant_params
        params.require(:complainant).permit(:name, :last_name,:ci, :phone, :address)
      end
  end
