class ComplainsController < ApplicationController

    before_action :authenticate_user!
    before_action :set_complain, only: [:show, :edit, :update, :destroy]
    before_action :verify_password_change
    autocomplete :complain, :contravertion
    autocomplete :complain, :crime
    def index
        if user_signed_in?
            @role_current_user = current_user.role

          if      @role_current_user==1
              @patrol_units = Array.new
            PatrolUnit.all.each do |comp|
              if comp.name == nil
                comp.name=""
              end
              @patrol_units << [comp.code + ' ' + comp.name,comp.id]
            end

                if params[:search]
                  @complains = Complain.search(params[:search]).order("created_at DESC")
                else
                 @complains=Complain.where("created_at >?",DateTime.now-316 ).paginate(:page => params[:page], :per_page => 10)
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

        #   File.open("/home/nataly/1/aux/911/unidades", "r") do |f|

        #    f.each_line do |line|
        #    @aux2=line

        #    @aux = PatrolUnit.new
        #    if @aux2!=nil
        #        @aux.code =  @aux2
        #      if @aux.valid?

        #        @aux.save!
        #      end
        #    end
        #    end
        #  end
        @crimes = Array.new
        Crime.all.each do |comp|
          @crimes << [comp.code + ' ' + comp.name]
        end
        @contravertions = Array.new
        Contravertion.all.each do |comp|
          @contravertions << [comp.code + ' ' + comp.name]
        end
        @day = params[:day]
        @dayP = params[:dayP]
        @totalDaysDB = ComplainsAuxiliar.where('fecha >= ?', 3.year.ago).map { |p| p.fecha.beginning_of_day }.uniq.size
        @totalCrimes = ComplainsAuxiliar.where( "delito like ?", "%DH%").count
        @totalHoursDB = @totalDaysDB*24
        @averagePerDay= @totalCrimes.to_f/@totalDaysDB
        if params[:searchCrime] && @day=="day"
          @totalCrimesSearched = ComplainsAuxiliar.where( "delito like ?", "%#{params[:searchCrime].split[0...2].join(' ')}%").count
          @averageCrimePerDay = @totalCrimesSearched.to_f/@totalDaysDB
          @searchCrime =  params[:searchCrime]

        elsif params[:searchCrime] && @day=="hour"
           @totalCrimesSearched = ComplainsAuxiliar.where( "delito like ?", "%#{params[:searchCrime].split[0...2].join(' ')}%").count
           @averageCrimePerHour= @totalCrimesSearched.to_f/@totalHoursDB
           @searchCrime =  params[:searchCrime]
         end
         if params[:searchContravertion] && @day=="day"
           @totalContravertionsSearched = ComplainsAuxiliar.where( "contravencion like ?", "%#{params[:searchContravertion].split[0...2].join(' ')}%").count
           @averageContravertionsPerDay = @totalContravertionsSearched.to_f/@totalDaysDB
           @searchConstravertion =  params[:searchConstravertion]
         elsif params[:searchContravertion] && @day=="hour"
           @totalContravertionsSearched = ComplainsAuxiliar.where( "contravencion like ?", "%#{params[:searchContravertion].split[0...2].join(' ')}%").count
           @averageContravertionsPerHour= @totalContravertionsSearched.to_f/@totalHoursDB
           @searchContravertion =  params[:searchContravertion]
          end
          if params[:searchCrimeProbability] && @dayP=="day"
           @totalCrimesSearched = ComplainsAuxiliar.where( "delito like ?", "%#{params[:searchCrimeProbability].split[0...2].join(' ')}%").count
          @probabilityCrimePerDay = @totalCrimesSearched.to_f/@totalDaysDB
          
          @searchCrimeProbability =  params[:searchCrimeProbability]
           

        elsif params[:searchCrimeProbability] && @dayP=="hour"
           @totalCrimesSearched = ComplainsAuxiliar.where( "delito like ?", "%#{params[:searchCrimeProbability].split[0...2].join(' ')}%").count
           @probabilityCrimePerHour= @totalCrimesSearched.to_f/@totalHoursDB
           @searchCrimeProbability =  params[:searchCrimeProbability]
          
          end

          if params[:searchContravertionProbability] && @dayP=="day"
           @totalContravertionsSearched = ComplainsAuxiliar.where( "contravencion like ?", "%#{params[:searchContravertionProbability].split[0...2].join(' ')}%").count
           @probabilityContravertionsPerDay = @totalContravertionsSearched.to_f/@totalDaysDB
           @searchConstravertionProbability =  params[:searchConstravertionProbability]
           
         elsif params[:searchContravertionProbability] && @dayP=="hour"
           @totalContravertionsSearched = ComplainsAuxiliar.where( "contravencion like ?", "%#{params[:searchContravertionProbability].split[0...2].join(' ')}%").count
           @probabilityContravertionsPerHour= @totalContravertionsSearched.to_f/@totalHoursDB
           @searchContravertionProbability =  params[:searchContravertionProbability]
            
           
        end
        
          
          if params[:searchContravertionProbabilityDate] 
         @dateStart = params[:startdate]
         @dateEnd=params[:enddate]
          @dateStart = DateTime.new params[:startdate]["{:ampm=>true}(1i)"].to_i,params[:startdate] ["{:ampm=>true}(2i)"].to_i, params[:startdate]["{:ampm=>true}(3i)"].to_i, params[:startdate]["{:ampm=>true}(4i)"].to_i,  params[:startdate]["{:ampm=>true}(5i)"].to_i
          @dateEnd = DateTime.new params[:enddate]["{:ampm=>true}(1i)"].to_i, params[:enddate]["{:ampm=>true}(2i)"].to_i, params[:enddate]["{:ampm=>true}(3i)"].to_i, params[:enddate]["{:ampm=>true}(4i)"].to_i, params[:enddate]["{:ampm=>true}(5i)"].to_i

         @dateS=@dateStart.strftime("%d/%m/%Y") 
         @dateE=@dateEnd.strftime("%d/%m/%Y") 
         @hourE= @dateEnd.strftime("%H:%M")
         @hourS =@dateStart.strftime("%H:%M")
         @totalContravertionsSearched = ComplainsAuxiliar.where( "(fecha >= ? AND fecha <= ? ) AND  (hora >=? AND hora <=?) AND contravencion like ?", "#{@dateS}","#{@dateE}","#{@hourS}","#{@hourE}","#{params[:searchContravertionProbabilityDate]}").count
         @probabilityContravertionsProbabilityDate = @totalContravertionsSearched.to_f/@totalDaysDB
         @searchContravertionProbabilityDate =  params[:searchContravertionProbabilityDate]

           
          end
    
 if params[:searchCrimeProbabilityDate] 
         @dateStart = params[:startdate]
         @dateEnd=params[:enddate]
         @dateStart = DateTime.new params[:startdate]["{:ampm=>true}(1i)"].to_i,params[:startdate] ["{:ampm=>true}(2i)"].to_i, params[:startdate]["{:ampm=>true}(3i)"].to_i, params[:startdate]["{:ampm=>true}(4i)"].to_i,  params[:startdate]["{:ampm=>true}(5i)"].to_i
          @dateEnd = DateTime.new params[:enddate]["{:ampm=>true}(1i)"].to_i, params[:enddate]["{:ampm=>true}(2i)"].to_i, params[:enddate]["{:ampm=>true}(3i)"].to_i, params[:enddate]["{:ampm=>true}(4i)"].to_i, params[:enddate]["{:ampm=>true}(5i)"].to_i

         @dateS=@dateStart.strftime("%d/%m/%Y") 
         @dateE=@dateEnd.strftime("%d/%m/%Y") 
         @hourE= @dateEnd.strftime("%H:%M")
         @hourS =@dateStart.strftime("%H:%M")
         @totalCrimeSearched = ComplainsAuxiliar.where( "(fecha >= ? AND   @averageCrimePerDay = @totalCrimesSearched.to_f/@totalDaysDB fecha <= ? ) AND  (hora >=? AND hora <=?) AND delito like ?", "#{@dateS}","#{@dateE}","#{@hourS}","#{@hourE}","#{params[:searchCrimeProbabilityDate]}").count
         @probabilityCrimeProbabilityDate = @totalCrimesSearched.to_f/@totalDaysDB
         @searchCrimerobabilityDate =  params[:searchCrimesrobabilityDate]

        
    end

 if params[:searchCrimeProbabilityDateZone] 
         @zoneCrime =  check_box_params[:zoneCrime]
         @turnHour=check_box_params[:turnHour]
         puts "dsds"
         puts check_box_params[:turnHour]
         puts "DSD"
         puts  check_box_params[:zoneCrime]
         @hourS= @turnHour.split('-')[0]
         @hourE= @turnHour.split('-')[1]
         
         @totalCrime = ComplainsAuxiliar.where( "delito like ?","#{params[:searchCrimeProbabilityDateZone]}").count
        @probabiliteCrime= @totalCrime.to_f/@totalCrimes.to_f
        puts "@totalCrime"
         puts @totalCrime
         puts "@totalCrimes"
          puts @totalCrimes
         puts "proCrimes"
         puts @probabiliteCrime
         puts  @totalCrime.to_f/@totalCrimes.to_f
        @totalCrimeZone = ComplainsAuxiliar.where( "delito like ? AND ZonaUrbana like ?","#{params[:searchCrimeProbabilityDateZone]}","#{check_box_params[:zoneCrime]}").count
         
        @norte = ComplainsAuxiliar.where( "delito like ? AND ZonaUrbana like ?","#{params[:searchCrimeProbabilityDateZone]}","NORTE").count
         @oeste = ComplainsAuxiliar.where( "delito like ? AND ZonaUrbana like ?","#{params[:searchCrimeProbabilityDateZone]}","OESTE").count
         @sud = ComplainsAuxiliar.where( "delito like ? AND ZonaUrbana like ?","#{params[:searchCrimeProbabilityDateZone]}","SUD").count
         
         puts "@totalCrimeZone"
         puts @totalCrimeZone
         puts "DSDmm"
         #@totalCrimeZone
           @error =  ( ((@probabiliteCrime * (1- @probabiliteCrime) ) / @averagePerDay)**0.5)*1.96
    
         puts "DSD"
       #  @totalCrimeHourZ = ComplainsAuxiliar.where( "(hora BETWEEN >=? AND  <=?) AND delito like ?","#{@hourS}","#{@hourE}","#{params[:searchCrimeProbabilityDateZone]}").count
         puts @totalCrimeHourZ
           puts "@totalCrimeHourZ"
         @probabilityZone=  @totalCrimeZone /@totalCrimes
         puts "dsds"
         puts @probabiliyZone
         puts @totalCrimeHourZ

         @searchCrimeProbabilityDateZone=params[:searchCrimeProbabilityDateZone] 
         @zoneCrime=check_box_params[:zoneCrime]
         puts "DSD"
         @probabilityCrimeProbabilityDateZone = @probabiliteCrime.to_f*@probabiliteCrime.to_f
            @error =  ( ((@probabilityCrimeProbabilityDateZone *(1- @probabilityCrimeProbabilityDateZone ))/@averagePerDay)**0.5)*1.96
         @expectedCrime= @averagePerDay *  @probabilityCrimeProbabilityDateZone 
         @confidenceIntervalD =  (@probabilityCrimeProbabilityDateZone.to_f-@error ) *100
         @confidenceIntervalU =  (@probabilityCrimeProbabilityDateZone.to_f+@error ) *100
         @probabilityCrimeProbabilityDateZone=@probabilityCrimeProbabilityDateZone.to_f*100
    end
    end


    def index2

         
   
      @dateStart = params[:startdate]
         @dateEnd=params[:enddate]
         #if @dateStart!=nil
         # @dateStart = DateTime.new params[:startdate]["{:ampm=>true}(1i)"].to_i,params[:startdate] ["{:ampm=>true}(2i)"].to_i, params[:startdate]["{:ampm=>true}(3i)"].to_i, params[:startdate]["{:ampm=>true}(4i)"].to_i,  params[:startdate]["{:ampm=>true}(5i)"].to_i
          #@dateEnd = DateTime.new params[:enddate]["{:ampm=>true}(1i)"].to_i, params[:enddate]["{:ampm=>true}(2i)"].to_i, params[:enddate]["{:ampm=>true}(3i)"].to_i, params[:enddate]["{:ampm=>true}(4i)"].to_i, params[:enddate]["{:ampm=>true}(5i)"].to_i

         #@dateS=@dateStart.strftime("%d/%m/%Y") 
        # @dateE=@dateEnd.strftime("%d/%m/%Y") 
        # @hourE= @dateEnd.strftime("%H:%M")
         #@hourS =@dateStart.strftime("%H:%M")
         @totalDaysDB =10000
        #@totalDaysDB = ComplainsAuxiliar.where('fecha >= ?', 3.year.ago).map { |p| p.fecha.beginning_of_day }.uniq.size
        @totalCrimes = ComplainsAuxiliar.where( "delito like ?", "%DH%").count
        @totalHoursDB = @totalDaysDB*24
        @totalCrime = ComplainsAuxiliar.where( "delito is NOT NULL").count
        @averagePerDay= @totalCrime.to_f/@totalDaysDB.to_f
      puts @averagePerDay
         puts  @totalCrime.to_f/@totalCrimes.to_f
        
        @norE= ComplainsAuxiliar.where( "delito  is NOT NULL AND 'complains_auxiliars.ZonaUrbana' like ? ","Nor Este").count
        @norO = ComplainsAuxiliar.where( "delito  is NOT NULL AND  'complains_auxiliars.ZonaUrbana'  like ? ","Nor Oeste").count
        @centralN = ComplainsAuxiliar.where( "delito  is NOT NULL AND 'complains_auxiliars.ZonaUrbana'  like ?","Central Norte").count
       # @aux= Crime.joins(:complain).where(("created_at >= ? and created_at <= ? and dayofweek(created_at) = ? ", '2014-11-09 09:00', '2014-11-17 09:00',1 ) :created_at =>Complain.select("max(created_at) as created_at").group("date_trunc('day',created_at)")).count
     #  @aux= Complain.joins(:crime).where(:created_at => [('2014-11-09 09:00')..('2014-11-17 09:00')],:created_at => ['dayofweek(created_at) = ?', 1]).count
             # @aux= Complain.joins(:crime).where(:created_at => [('2014-11-09 09:00')..('2014-11-17 09:00')],:created_at => ['dayofweek(created_at) = ?', 1],:created_at =>Complain.select("max(created_at) as created_at").group("date_trunc('day',created_at)")).count

             #puts @aux
             #Complain.select("max(created_at)  as created_at").group("max(created_at) ")
         @centralS= ComplainsAuxiliar.where( "delito  is NOT NULL AND  'complains_auxiliars.ZonaUrbana'  like ? ","Central Sud").count
         @surE= ComplainsAuxiliar.where( "delito  is NOT NULL AND  'complains_auxiliars.ZonaUrbana'  like ? ","Sud Este").count
         @surO = ComplainsAuxiliar.where( "delito  is NOT NULL AND  'complains_auxiliars.ZonaUrbana'  like ? ","Sud Oeste").count
         
         @probNE= @norE.to_f/ @totalCrime.to_f 
         @errorNE =   ((( @probNE * (1-  @probNE )) / @averagePerDay)**0.5)*1.96       
         @espNE= @averagePerDay *  @probNE 
         @inINE =  (@probNE.to_f-@errorNE ) *100
         @inSNE =  (@probNE.to_f+@errorNE ) *100
         @probNE=@probNE.to_f*100

         @probNO= @norO.to_f/ @totalCrime.to_f
         puts @nor0.to_f   
         puts  @totalCrime.to_f
         puts   @probN0    

         @errorNO =   ((( @probNO * (1-  @probNO )) / @averagePerDay)**0.5)*1.96
         @espNO= @averagePerDay *  @probNO 
         @inINO =  (@probNO.to_f-@errorNO) *100
         @inSNO =  (@probNO.to_f+@errorNO ) *100
         @probN0=@probN0.to_f*100

         @probCN= @centralN.to_f/ @totalCrime.to_f 
         @errorCN =   ((( @probCN * (1-  @probCN )) / @averagePerDay)**0.5)*1.96  
         @espCN= @averagePerDay *  @probCN 
         @inICN =  (@probCN.to_f-@errorCN ) *100
         @inSCN =  (@probCN.to_f+@errorCN ) *100
         @probCN=@probCN.to_f*100

         @probCS= @centralS.to_f/ @totalCrime.to_f 
         @errorCS =   ((( @probCS * (1-  @probCS )) / @averagePerDay)**0.5)*1.96
        
         @espCS= @averagePerDay *  @probCS 
         @inICS =  (@probCS.to_f-@errorCS ) *100
         @inSCS =  (@probCS.to_f+@errorCS ) *100
         @probCS=@probCS.to_f*100
 
        @probSE= @surE.to_f/ @totalCrime.to_f 
         @errorSE =   ((( @probSE * (1-  @probSE )) / @averagePerDay)**0.5)*1.96       
         @espSE= @averagePerDay *  @probSE.to_f 
         @inISE =  (@probSE.to_f-@errorSE ) *100
         @inSSE =  (@probSE.to_f+@errorSE ) *100
         @probSE=@probSE.to_f*100

         @probSO= @surO.to_f/ @totalCrime.to_f          
         @errorSO =   ((( @probSO * (1-  @probSO )) / @averagePerDay)**0.5)*1.96
         @espSO= @averagePerDay *  @probSO 
         @inISO =  (@probSO.to_f-@errorSO ) *100
         @inSSO =  (@probSO.to_f+@errorSO ) *100
         @probSO=@probSO.to_f*100
        #  end
    end
    def index3
     #@differenceHour=(((strftime('%s', '2011-11-10 11:46') - strftime('%s', '2011-11-09 09:00')) % (60 * 60 * 24)) / (60 * 60) 

          ComplainsAuxiliar.all.where("id > 17029").each do |comp|
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
     end
      @complain.derivationCase=@complainAux.remisionCaso
      @complain.shortReport =@complainAux.breveInforme
      @complain.protagonists= @complainAux.protagonista
       @complain.save!
     end  
    end
         
    end

    def index_aux


# @aux= Complain.joins(:crime).where(:created_at =>Complain.select("max(created_at) as created_at").group("date_trunc('day',created_at)"))..wcount
 # @aux= Complain.joins(:crime).where(:created_at => [('2014-11-09 09:00')..('2014-11-17 09:00')],:created_at => ['dayofweek(created_at) = ?', 1],:created_at =>Complain.select("max(created_at) as created_at").group("date_trunc('day',created_at)")).count
 # @aux = Complain.joins(:crime).where(('dayofweek(created_at) = ? AND created_at BETWEEN ? AND ?', 1, '2014-11-09 09:00','2014-11-17 09:00').where.(:created_at =>Complain.select("max(created_at) as created_at").group("date_trunc('day',created_at)"))).count
 # @aux= Complain.joins(:crime).select("max(created_at) as created_at").where(:created_at => [('2014-11-09 09:00')..('2014-11-17 09:00')],:created_at => ['extract  dow 
#from created_at  ? , 1])
 
  @aux= Complain.where("created_at >= ? and created_at <= ? and dayofweek(created_at) = ? ", '2014-11-09 09:00', '2014-11-17 09:00',1 ).joins(:crime)
 puts @aux
   #@aux= Complain.joins(:crime).select(("max(created_at) as created_at").

    # SELECT MAX(created_at) AS created_at FROM complains WHERE  extract (dow 
#from created_at )= 1  and  created_at BETWEEN '2014-11-09 09:00' AND '2014-11-17 09:00' ;
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
        params.require(:complain).permit( :contravertion,:crime, :crime_checkbox , :contravertion_checkbox, :crimeAux,  :crime_id,:contravertion_id,:auxCrime, :auxContravertion, :observations,:patrol_unit,:turnHour,:zoneCrime)
      end
      def complainant_params
        params.require(:complainant).permit(:name, :last_name,:ci, :phone, :address)
      end
  end
