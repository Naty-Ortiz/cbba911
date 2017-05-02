class ComplainsController < ApplicationController

    before_action :authenticate_user!
    before_action :set_complain, only: [:show, :edit, :update, :destroy]
    before_action :verify_password_change

     helper_method :getColor
    def index
      record_activity("Visualizacion de denuncias")
       if user_signed_in?
          @patrol_units = Array.new
            @role_current_user = current_user.role
            @auxCrime=false
          if      @role_current_user==1

            PatrolUnit.all.each do |comp|
              if comp.name == nil
                comp.name=""
              end
              @patrol_units << [comp.code + ' ' + comp.name]

             end


                if params[:search]
                  @complains = Complain.search(params[:search]).order("created_at DESC")
                else
                 @complains=Complain.where("created_at <?",DateTime.now ).paginate(:page => params[:page], :per_page => 10).order("created_at DESC")
                end
          elsif  @role_current_user==2
                if params[:search]
                  @complains = Complain.search(params[:search]).order("created_at DESC")
                else
                   @complains=Complain.where("created_at <?",DateTime.now ).paginate(:page => params[:page], :per_page => 10).order("created_at DESC")

                end
          end
        end
    end
    # GET /complains/1
    # GET /complains/1.json
    def all_complains
      if user_signed_in?
          @patrol_units = Array.new
            @role_current_user = current_user.role
            @auxCrime=false
          if      @role_current_user==1

            PatrolUnit.all.each do |comp|
              if comp.name == nil
                comp.name=""
              end
              @patrol_units << [comp.code + ' ' + comp.name]

             end


                if params[:search]
                  @complains = Complain.search(params[:search]).order("created_at DESC")
                else
                 @complains=Complain.where("created_at <?",DateTime.now ).paginate(:page => params[:page], :per_page => 10).order("created_at DESC")
                end
          elsif  @role_current_user==2
                if params[:search]
                  @complains = Complain.search(params[:search]).order("created_at DESC")
                else
                   @complains=Complain.where("created_at <?",DateTime.now ).paginate(:page => params[:page], :per_page => 10).order("created_at DESC")

                end
          end
        end
    end 
    def show
       @patrol_units = Array.new
            PatrolUnit.all.each do |comp|
              if comp.name == nil
                comp.name=""
              end
              @patrol_units << [comp.code + ' ' + comp.name]

            end
      @observationsAux = params[:observationsAux]
      @caseReportAux = params[:caseReportAux]
      @complain = Complain.find(params[:id])
      @asign_patrol_unit=params[:asign_patrol_unit]
      @complainant = Complainant.where(:complain_id => @complain.id).first

    end



    def getColor(prob)

      prob=prob.round(2)
      puts "prob"
      puts prob
      puts "prob"
      if prob>=0.0 && prob<=0.30
       return "#1B592B"
      end
      if  prob>=0.31 && prob<=0.499999
         return "#0431B4"
      end
      if prob>=0.50 && prob<=0.79
         return "#E8F853"
      end
        if prob>=0.80 && prob<=1
          return"#DF0101"
        end
      end

    def index2
    @complain= Complain.new
    record_activity("visualizacion de probabilidad de delitos")
    @dateStart =  params[:startdate]

    puts "params"
    puts params
    puts "params"
     if @dateStart!=nil&&@dateStart!=""
      @aux=@dateStart
        @aux2=@aux.split(' ')[1..-1].join(' ')
        @aux2=@aux.chomp(' AM')
        puts @aux2
        puts "sdfsdfdsfdsfdfssdf"
        puts (@aux2.split("/")[2]).partition(" ").first.to_i
        puts "sfsdfsdfsdfsdf"
        puts (@aux.split(":")[0]).to_i
puts "sdsdas"
        @aux= DateTime.new( (@aux2.split("/")[2]).partition(" ").first.to_i,(@aux2.split("/")[0]).to_i,(@aux2.split("/")[1]).to_i,  (@aux.split(":")[0]).to_i+12, ( @aux.split(":")[1]).to_i, 0,0)
      @dateStartToTime = @aux
      @aux= @aux.to_s
      else

           @dateStart=Time.now.to_s
           @aux=@dateStart
           @aux2=@dateStart
           @dateStartToTime = Time.now
       if params[:complain]!=nil
          @turn=params[:complain][:turnHour]
         if params[:complain][:startdate]!=nil
          @dateStart = params[:complain][:startdate]

          @aux=@dateStart
          @aux2=@dateStart
           @dateStartToTime =Time.parse(@aux)
         end
        end
     end
     puts "aux"
     puts @aux
     puts "aux2"
     puts @aux2
     puts " df"
     puts @dateStartToTime
     puts "start"


    @dateEnd=params[:enddate]

    @totalTodayDays = Complain.group("date_trunc('day',complains.created_at)").where('EXTRACT(DOW FROM complains.created_at) = ? and complains.created_at BETWEEN ? AND ? ', Time.parse(@aux).wday , @dateBegin,@dateFinal).count.size

    @aux1 = Complain.joins(:crime).last
   # @dateStartToTime =Time.now
    @probOfDay=1
    @dateBegin = Complain.first.created_at
    @dateFinal =Complain.last.created_at
    @totalDaysDB = Complain.group("date_trunc('day',complains.created_at)").where('  complains.created_at BETWEEN ? AND ? ', @dateBegin,@dateFinal).count.size
    puts  @totalDaysDB
    @thereIsRecordsInDB = true
    @turnHour=""

    if @dateStart!=nil && @dateStart!=""
    if ((@aux.to_i>=@dateBegin.to_i )&&(@aux.to_i <=@dateFinal.to_i) )
       @dateStartToTime=  @aux
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



    puts @totalDaysDB
    @totalHoursDB = 24 * @totalDaysDB
   @dateBegin = Complain.first.created_at
         @dateFinal =Complain.last.created_at
    if @dateStart!=nil && @dateStart!=""
     if ( @aux.to_i>Time.now.to_i)
      @probOfDay= @totalTodayDays.to_f/@totalDaysDB
     end
    end
       @totalHoursTodayDays = @totalTodayDays *8

       @totalCrimes = Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).count
       @totalContravertions = Contravertion.joins(:complain).count
        @totalHoursDB = @totalDaysDB*24
        @totalCrimesDayToday = Complain.where( ' EXTRACT(DOW FROM complains.created_at) = ? and complains.created_at BETWEEN ? AND ? ',@dateStartToTime.wday , @dateBegin,@dateFinal).includes(:crimes).count
        @totalCrimesDayTodayBetween8to16 =  Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( ' EXTRACT(DOW FROM complains.created_at) = ?  and complains.created_at::time BETWEEN ? AND ? and complains.created_at BETWEEN ? AND ? ', @dateStartToTime.wday , '08:00:00','15:59:59' , @dateBegin,@dateFinal).count
        @totalCrimesDayTodayBetween16to0 =  Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( 'EXTRACT(DOW FROM complains.created_at) = ?  and   complains.created_at::time BETWEEN ? AND ? and complains.created_at BETWEEN ? AND ? ', @dateStartToTime.wday , '16:00:00','23:59:59' , @dateBegin,@dateFinal).count
            puts "total"
        @totalCrimesDayTodayBetween0to8 =  Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( ' EXTRACT(DOW FROM complains.created_at) = ?  and  complains.created_at::time BETWEEN ? AND ? and complains.created_at BETWEEN ? AND ? ', @dateStartToTime.wday , '00:00:00','07:59:59'  , @dateBegin,@dateFinal).count
        @totalCrimesZoneNorEste=  Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( ' complains.zone = ? ', 'Nor Este').count
        @totalContravertionsZoneNorEste=  Complain.joins(:contravertion).where( '  complains.zone = ? ', 'Nor Este').count
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
      @totalContravertionsZoneNorOeste=   Complain.joins(:contravertion).where( ' complains.zone = ? ', 'Nor Oeste').count
      @probZoneNO= ( @totalCrimesZoneNorOeste.to_f+@totalContravertionsZoneNorOeste)/ (@totalCrimes+@totalContravertions)
      @probNO8to16 =(  @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange8to16.to_f ) / @probZoneNO.to_f
      @probNO16to0 =(  @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange16to0.to_f ) / @probZoneNO.to_f
      @probNO16to0=@probNO16to0.round(1)
      @probNO0to8 =(  @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange0to8.to_f ) / @probZoneNO.to_f
       @probNO0to8 = @probNO0to8.round(1)
      #fin nor oeste
      #CENTRAL NORTE
      @totalCrimesZoneCentralNorte=   Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( '  complains.zone = ? ', 'Nor Oeste').count
      @totalContravertionsZoneCentralNorte=  Complain.joins(:contravertion).where( '  complains.zone = ? ', 'Central Norte').count
      @probZoneCN= ( @totalCrimesZoneCentralNorte.to_f+@totalContravertionsZoneCentralNorte)/ (@totalCrimes+@totalContravertions)
      @probCN8to16 =( @probOfDay*  @probDayCrime.to_f *  @probDayAndHourRange8to16.to_f ) / @probZoneCN.to_f
      @probCN16to0 =( @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange16to0.to_f ) / @probZoneCN.to_f
      @probCN0to8 =(  @probOfDay*@probDayCrime.to_f *  @probDayAndHourRange0to8.to_f ) / @probZoneCN.to_f
      # FIN CN
      #ini cs
       @totalCrimesZoneCentralSud=  Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( ' complains.zone = ? ', 'Nor Oeste').count
      @totalContravertionsZoneCentralSud=  Complain.joins(:contravertion).where( '  complains.zone = ? ', 'Central Sud').count
      @probZoneCS= ( @totalCrimesZoneCentralSud.to_f+@totalContravertionsZoneCentralSud)/ (@totalCrimes+@totalContravertions)
      @probCS8to16 =(  @probOfDay*@probDayCrime.to_f *  @probDayAndHourRange8to16.to_f ) / @probZoneCS.to_f
      @probCS16to0 =( @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange16to0.to_f ) / @probZoneCS.to_f
      @probCS0to8 =(  @probOfDay*@probDayCrime.to_f *  @probDayAndHourRange0to8.to_f ) / @probZoneCS.to_f
     #fin cs
     #ini sud este
      @totalCrimesZoneSudEste=   Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where(   'complains.zone = ? ', 'Nor Oeste').count
      @totalContravertionsZoneSudEste=  Complain.joins(:contravertion).where( ' complains.zone = ? ', 'Sud Este').count
      @probZoneSE= ( @totalCrimesZoneSudEste.to_f+@totalContravertionsZoneSudEste)/ (@totalCrimes+@totalContravertions)
      @probSE8to16 =( @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange8to16.to_f ) / @probZoneSE.to_f
      @probSE16to0 =( @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange16to0.to_f ) / @probZoneSE.to_f
      @probSE0to8 =(  @probOfDay*@probDayCrime.to_f *  @probDayAndHourRange0to8.to_f ) / @probZoneSE.to_f

    #fin sud este
     #ini sud oeste
     @totalCrimesZoneSudEste=   Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( ' complains.zone = ? ', 'Nor Oeste').count
      @totalContravertionsZoneSudEste=  Complain.joins(:contravertion).where( '  complains.zone = ? ', 'Sud Oeste').count
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
         @items= Array.new()
         if @turn!=nil

      puts case @turn

      when '8:00-16:00'
        @turnHour="Turno manhana"
         @items= @items.clear()
        @items <<(@probNO8to16*100).round(2)
        @items <<(@probNE8to16*100).round(2)
        @items <<(@probCN8to16*100).round(2)
        @items <<(@probCS8to16*100).round(2)
        @items <<(@probSO8to16*100).round(2)
        @items <<(@probSE8to16*100).round(2)
        puts"sad"
        puts@turnHour
      when '16:00-00:00'
        @items= @items.clear()
         @turnHour="Turno tarde"
      
      @items <<(@probNO0to8*100).round(2)
        @items <<(@probNE0to8*100).round(2)
        @items <<(@probCN0to8*100).round(2)
        @items <<(@probCS0to8*100).round(2)
        @items <<(@probSO0to8*100).round(2)
        @items <<(@probSE0to8*100).round(2)
          puts"sad2"
        puts@turnHour
      when '00:00-08:00'
         @items= @items.clear()
         @turnHour="Turno noche"
        @items <<(@probNO16to0*100).round(2)
        @items <<(@probNE16to0*100).round(2)
        @items <<(@probCN16to0*100).round(2)
        @items <<(@probCS16to0*100).round(2)
        @items <<(@probSO16to0*100).round(2)
        @items <<(@probSE16to0*100).round(2)

          puts"sad3"
        puts@turnHour
      end
    end


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

    def index_contravertions

    @complain= Complain.new
    record_activity("visualizacion de probabilidad de contraverciones")
    @dateStart =  params[:startdate]
     if @dateStart!=nil&&@dateStart!=""
      @aux=@dateStart
        @aux2=@aux.split(' ')[1..-1].join(' ')
        @aux2=@aux.chomp(' AM')
        @aux= DateTime.new( (@aux2.split("/")[2]).partition(" ").first.to_i,(@aux2.split("/")[0]).to_i,(@aux2.split("/")[1]).to_i,  (@aux.split(":")[0]).to_i, ( @aux.split(":")[1]).to_i, 0,0)
      @dateStartToTime = @aux
      @aux= @aux.to_s
      else

           @dateStart=Time.now.to_s
           @aux=@dateStart
           @aux2=@dateStart
           @dateStartToTime = Time.now
        if params[:complain]!=nil
          @turn=params[:complain][:turnHour]
         if params[:complain][:startdate]!=nil
          @dateStart = params[:complain][:startdate]

          @aux=@dateStart
          @aux2=@dateStart
           @dateStartToTime =Time.parse(@aux)
         end
        end
     end



    @dateEnd=params[:enddate]

    @totalTodayDays = Complain.group("date_trunc('day',complains.created_at)").where('EXTRACT(DOW FROM complains.created_at) = ? and complains.created_at BETWEEN ? AND ? ', Time.parse(@aux).wday , @dateBegin,@dateFinal).count.size

    @aux1 = Complain.joins(:crime).last
   # @dateStartToTime =Time.now
    @probOfDay=1
    @dateBegin = Complain.first.created_at
    @dateFinal =Complain.last.created_at
    @totalDaysDB = Complain.group("date_trunc('day',complains.created_at)").where('  complains.created_at BETWEEN ? AND ? ', @dateBegin,@dateFinal).count.size
    @thereIsRecordsInDB = true
    @turnHour=""

    if @dateStart!=nil && @dateStart!=""
    if ((@aux.to_i>=@dateBegin.to_i )&&(@aux.to_i <=@dateFinal.to_i) )
       @dateStartToTime=  @aux
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



    puts @totalDaysDB
    @totalHoursDB = 24 * @totalDaysDB
   @dateBegin = Complain.first.created_at
         @dateFinal =Complain.last.created_at
    if @dateStart!=nil && @dateStart!=""
     if ( @aux.to_i>Time.now.to_i)
      @probOfDay= @totalTodayDays.to_f/@totalDaysDB
     end
    end
       @totalHoursTodayDays = @totalTodayDays *8

       @totalCrimes = Complain.joins("JOIN contravertions ON contravertions.id = complains.contravertion_id " ).count
       @totalContravertions = Crime.includes(:complains).count
        @totalHoursDB = @totalDaysDB*24
        @totalCrimesDayToday = Complain.where( ' EXTRACT(DOW FROM complains.created_at) = ? and complains.created_at BETWEEN ? AND ? ',@dateStartToTime.wday , @dateBegin,@dateFinal).joins(:contravertion).count
        @totalCrimesDayTodayBetween8to16 =  Complain.joins("JOIN contravertions ON contravertions.id = complains.contravertion_id " ).where( ' EXTRACT(DOW FROM complains.created_at) = ?  and complains.created_at::time BETWEEN ? AND ? and complains.created_at BETWEEN ? AND ? ', @dateStartToTime.wday , '08:00:00','15:59:59' , @dateBegin,@dateFinal).count
        @totalCrimesDayTodayBetween16to0 =  Complain.joins("JOIN contravertions ON contravertions.id = complains.contravertion_id " ).where( 'EXTRACT(DOW FROM complains.created_at) = ?  and   complains.created_at::time BETWEEN ? AND ? and complains.created_at BETWEEN ? AND ? ', @dateStartToTime.wday , '16:00:00','23:59:59' , @dateBegin,@dateFinal).count
            puts "total"
        @totalCrimesDayTodayBetween0to8 =  Complain.joins("JOIN contravertions ON contravertions.id = complains.contravertion_id " ).where( ' EXTRACT(DOW FROM complains.created_at) = ?  and  complains.created_at::time BETWEEN ? AND ? and complains.created_at BETWEEN ? AND ? ', @dateStartToTime.wday , '00:00:00','07:59:59'  , @dateBegin,@dateFinal).count
        @totalCrimesZoneNorEste=  Complain.joins("JOIN contravertions ON contravertions.id = complains.contravertion_id " ).where( ' complains.zone = ? ', 'Nor Este').count
        @totalContravertionsZoneNorEste=  Complain.joins(:crime).where( '  complains.zone = ? ', 'Nor Este').count
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
      @totalCrimesZoneNorOeste=   Complain.joins("JOIN contravertions ON contravertions.id = complains.contravertion_id " ).where( ' complains.zone = ? ', 'Nor Oeste').count
      @totalContravertionsZoneNorOeste=   Complain.joins(:crime).where( ' complains.zone = ? ', 'Nor Oeste').count
      @probZoneNO= ( @totalCrimesZoneNorOeste.to_f+@totalContravertionsZoneNorOeste)/ (@totalCrimes+@totalContravertions)
      @probNO8to16 =(  @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange8to16.to_f ) / @probZoneNO.to_f
      @probNO16to0 =(  @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange16to0.to_f ) / @probZoneNO.to_f
      @probNO16to0=@probNO16to0.round(1)
      @probNO0to8 =(  @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange0to8.to_f ) / @probZoneNO.to_f
       @probNO0to8 = @probNO0to8.round(1)
      #fin nor oeste
      #CENTRAL NORTE
      @totalCrimesZoneCentralNorte=   Complain.joins("JOIN contravertions ON contravertions.id = complains.contravertion_id " ).where( '  complains.zone = ? ', 'Nor Oeste').count
      @totalContravertionsZoneCentralNorte=  Complain.joins(:crime).where( '  complains.zone = ? ', 'Central Norte').count
      @probZoneCN= ( @totalCrimesZoneCentralNorte.to_f+@totalContravertionsZoneCentralNorte)/ (@totalCrimes+@totalContravertions)
      @probCN8to16 =( @probOfDay*  @probDayCrime.to_f *  @probDayAndHourRange8to16.to_f ) / @probZoneCN.to_f
      @probCN16to0 =( @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange16to0.to_f ) / @probZoneCN.to_f
      @probCN0to8 =(  @probOfDay*@probDayCrime.to_f *  @probDayAndHourRange0to8.to_f ) / @probZoneCN.to_f
      # FIN CN
      #ini cs
       @totalCrimesZoneCentralSud=  Complain.joins("JOIN contravertions ON contravertions.id = complains.contravertion_id " ).where( ' complains.zone = ? ', 'Nor Oeste').count
      @totalContravertionsZoneCentralSud=  Complain.joins(:crime).where( '  complains.zone = ? ', 'Central Sud').count
      @probZoneCS= ( @totalCrimesZoneCentralSud.to_f+@totalContravertionsZoneCentralSud)/ (@totalCrimes+@totalContravertions)
      @probCS8to16 =(  @probOfDay*@probDayCrime.to_f *  @probDayAndHourRange8to16.to_f ) / @probZoneCS.to_f
      @probCS16to0 =( @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange16to0.to_f ) / @probZoneCS.to_f
      @probCS0to8 =(  @probOfDay*@probDayCrime.to_f *  @probDayAndHourRange0to8.to_f ) / @probZoneCS.to_f
     #fin cs
     #ini sud este
      @totalCrimesZoneSudEste=   Complain.joins("JOIN contravertions ON contravertions.id = complains.contravertion_id " ).where(   'complains.zone = ? ', 'Nor Oeste').count
      @totalContravertionsZoneSudEste=  Complain.where( ' complains.zone = ? ', 'Sud Este').joins(:crime).count
      @probZoneSE= ( @totalCrimesZoneSudEste.to_f+@totalContravertionsZoneSudEste)/ (@totalCrimes+@totalContravertions)
      @probSE8to16 =( @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange8to16.to_f ) / @probZoneSE.to_f
      @probSE16to0 =( @probOfDay* @probDayCrime.to_f *  @probDayAndHourRange16to0.to_f ) / @probZoneSE.to_f
      @probSE0to8 =(  @probOfDay*@probDayCrime.to_f *  @probDayAndHourRange0to8.to_f ) / @probZoneSE.to_f

    #fin sud este
     #ini sud oeste
     @totalCrimesZoneSudEste=   Complain.joins("JOIN contravertions ON contravertions.id = complains.contravertion_id " ).where( ' complains.zone = ? ', 'Nor Oeste').count
      @totalContravertionsZoneSudEste=  Complain.where( '  complains.zone = ? ', 'Sud Oeste').joins(:crime).count
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
         @items= Array.new()
         if @turn!=nil

      puts case @turn

      when '8:00-16:00'
        @turnHour="Turno manhana"
         @items= @items.clear()
        @items <<(@probNO8to16*100).round(2)
        @items <<(@probNE8to16*100).round(2)
        @items <<(@probCN8to16*100).round(2)
        @items <<(@probCS8to16*100).round(2)
        @items <<(@probSO8to16*100).round(2)
        @items <<(@probSE8to16*100).round(2)
        puts"sad"
        puts@turnHour
      when '16:00-00:00'
        @items= @items.clear()
         @turnHour="Turno tarde"
        @items <<(@probNO16to0*100).round(2)
        @items <<(@probNE16to0*100).round(2)
        @items <<(@probCN16to0*100).round(2)
        @items <<(@probCS16to0*100).round(2)
        @items <<(@probSO16to0*100).round(2)
        @items <<(@probSE16to0*100).round(2)

          puts"sad2"
        puts@turnHour
      when '00:00-08:00'
         @items= @items.clear()
         @turnHour="Turno noche"
        @items <<(@probNO0to8*100).round(2)
        @items <<(@probNE0to8*100).round(2)
        @items <<(@probCN0to8*100).round(2)
        @items <<(@probCS0to8*100).round(2)
        @items <<(@probSO0to8*100).round(2)
        @items <<(@probSE0to8*100).round(2)

          puts"sad3"
        puts@turnHour
      end
    end


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
@newPatrolUnit= PatrolUnit.new
          ComplainsAuxiliar.all.where("id > 65479").each do |comp|
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

        if @complainAux.unidadAsignada==nil
           @complainAux.unidadAsignada="MP-33"

        end

        @complain.patrol_unit_id = PatrolUnit.where(:code =>(@complainAux.unidadAsignada.upcase)).pluck(:id).first.to_i
        puts "entra 1"
      if  @complain.patrol_unit_id ==0
            puts "entra 2"
        @complain.patrol_unit_id = PatrolUnit.where(:code =>(@complainAux.unidadAsignada.upcase)).pluck(:id).first.to_i



            @patrol_unit_params= @complainAux.unidadAsignada.delete("\n")
            @patrol_unit_params=@complainAux.unidadAsignada.gsub(/^A-Za-z0-9-,/, '')
            @patrol_unit_params=@complainAux.unidadAsignada.strip
            @auxPatrolUnit = PatrolUnit.where(:code =>(@patrol_unit_params)).pluck(:id).first.to_i
            puts "sdfsdssdfzzzzzzzzz"
            puts @auxPatrolUnit
            puts "ASD"
          if  @auxPatrolUnit==0

             @newPatrolUnit.code = @patrol_unit_params
             puts "otri"
             puts  @newPatrolUnit.code
             puts "iiui"
             @newPatrolUnit.name= ""
             if @newPatrolUnit.valid?
              puts "mbnmnmmmm"
              @aux=true
              @newPatrolUnit.save!
             puts "@newPatrolUnit.id"
               @complain.patrol_unit_id =  @newPatrolUnit.id

             else

              flash[:error]= 'Error al asignar unidad'+ '\n\n'
             format.html { redirect_to action: "show", error: 'Error al asignar unidad' ,:patrolUnitAsign => true, :patrolUnitAux =>  @patrol_unit_params}

             end
        else
          puts "eerwreeer"
         @complain.patrol_unit_id =  @auxPatrolUnit
        end
      end
      puts "complain.patrol_unit_id "
      puts @complain.patrol_unit_id

      @complain.derivationCase=@complainAux.remisionCaso
      @complain.shortReport =@complainAux.breveInforme
      @complain.protagonists= @complainAux.protagonista
       @complain.save!
     end
    end

    end

def graph_report
   record_average
  @dateStart =  params[:startdate]
  @dateEnd=params[:enddate]
  puts "para"
  puts params[:commit]
  puts "zzf"
  puts @dateStart
    puts "zzf"
  puts @dateEnd
      respond_to do |format|
        if params[:commit]!=nil
          puts "date"
          @dateStart == nil ? (puts "Santa's On His Way!") : (puts "Snow")
          puts "fdsff"
     if (@dateStart==nil || @dateStart=="") then
      flash[:error]= 'Debe ingresar la fecha inicial correctamente'+ '\n\n'
     format.html { redirect_to action: "graph_report", error: 'Debe ingresar la fecha inicial correctamente' }

    else
      @aux=@dateStart
      @aux2=@aux
        @aux2=@aux.split(' ')[1..-1].join(' ')
        @aux2=@aux.chomp(' AM')
        @aux= DateTime.new( (@aux2.split("/")[2]).partition(" ").first.to_i,(@aux2.split("/")[0]).to_i,(@aux2.split("/")[1]).to_i,  (@aux.split(":")[0]).to_i, ( @aux.split(":")[1]).to_i, 0,0)
      @dateBegin = @aux
    end
     if @dateEnd==nil||@dateEnd=="" then
      flash[:error]+= 'Debe ingresar la fecha final correctamente'+ '\n\n'
     format.html { redirect_to action: "graph_report", error: 'Debe ingresar la fecha  final correctamente' }
   else
    @auxEnd=@dateEnd
        @auxEnd2=@auxEnd.split(' ')[1..-1].join(' ')
        @auxEnd2=@auxEnd.chomp(' AM')
        @auxEnd= DateTime.new( (@auxEnd2.split("/")[2]).partition(" ").first.to_i,(@auxEnd2.split("/")[0]).to_i,(@auxEnd2.split("/")[1]).to_i,  (@auxEnd.split(":")[0]).to_i, ( @auxEnd.split(":")[1]).to_i, 0,0)
        @dateFinal= @auxEnd
    end
  else


  @dateBegin = Complain.first.created_at
  @dateFinal =Complain.last.created_at
end
@totalCrimes= Complain.where( ' "caseReport" = ?  and complains.created_at BETWEEN ? AND ?',true,  @dateBegin,@dateFinal).joins(:crime).count

@zones =  Complain.select('DISTINCT zone')
@total_crimes_per_zone = []
@zones.each do |zone |
  if zone.zone!=nil
@total_crimes_per_zone.push({
    :label => zone.zone,

    :value => Complain.where( ' complains.zone = ? and "caseReport" = ?  and complains.created_at BETWEEN ? AND ?', zone.zone, true,  @dateBegin,@dateFinal).joins(:crime).count
})
end
end
# Create a new FusionCharts instance that initializes the chart height, width, type, container div
# id, data source, and the data format
@chart = Fusioncharts::Chart.new({
    :height => 400,
    :width => 600,
    :type => 'pie3d',
    :renderAt => 'chart-container',

    # key - value pairs.
    :dataSource => {
        :chart => {
            :caption => 'Delitos por zonas',
            :subCaption => "",
            :startingAngle =>"120",
            :showLabels =>"0",
            :showLegend=> "1",
            :enableMultiSlicing => "0",
            :slicingDistance =>"15",
            :showPercentValues => "1",
            :showPercentInTooltip =>"0",
            :formatNumberScale=> "0",
            :decimalSeparator=> ",",
            :thousandSeparator=> ".",
            :plotTooltext =>"Zona : $label <br>Total delitos : $datavalue",
            :theme => 'fint',
        },
        # The data in the array of hashes is now stored in the `top_ten_populous_countries`
        # variable in the FusionCharts consumable format.
        :data => @total_crimes_per_zone
    }
})
@totalContravertions= Complain.where( ' "caseReport" = ?  and complains.created_at BETWEEN ? AND ?',true,  @dateBegin,@dateFinal).joins(:contravertion).count

@zones2 =  Complain.select('DISTINCT zone')
@total_contravertions_per_zone = []

@zones2.each do |zone |
  if zone.zone!=nil
@total_contravertions_per_zone.push({
    :label => zone.zone,
    :value =>Complain.where( ' complains.zone = ? and "caseReport" = ?  and complains.created_at BETWEEN ? AND ?', zone.zone, true,  @dateBegin,@dateFinal).joins(:contravertion).count
})
end
end
# Create a new FusionCharts instance that initializes the chart height, width, type, container div
# id, data source, and the data format
@chart2 = Fusioncharts::Chart.new({
    :height => 400,
    :width => 600,
    :type => 'pie3d',
    :renderAt => 'chart-container-contravention',

    # key - value pairs.
    :dataSource => {
        :chart => {
            :caption => 'Contravenciones por zonas',
            :subCaption => "",
            :startingAngle =>"120",
            :showLabels =>"0",
            :showLegend=> "1",
            :enableMultiSlicing => "0",
            :slicingDistance =>"15",
            :showPercentValues => "1",
            :showPercentInTooltip =>"0",
            :formatNumberScale=> "0",
            :decimalSeparator=> ",",
            :thousandSeparator=> ".",
            :plotTooltext =>"Zona : $label <br>Total contravenciones : $datavalue",
            :theme => 'fint',
        },
        # The data in the array of hashes is now stored in the `top_ten_populous_countries`
        # variable in the FusionCharts consumable format.
        :data => @total_contravertions_per_zone
    }
})

    format.html
   format.xlsx {
    response.headers['Content-Disposition'] = 'attachment; filename="all_products.xlsx"'
  }


end
end
def report

 @dateStart =  params[:startdate]
  @dateEnd=params[:enddate]
  @zone=params[:zone]

  @total_crimes_per_zone = []
      respond_to do |format|
if params[:commit]!=nil
          puts "date"
          @dateStart == nil ? (puts "Santa's On His Way!") : (puts "Snow")
          puts "fdsff"
     if (@dateStart==nil || @dateStart=="") then
      flash[:error]= 'Debe ingresar la fecha inicial correctamente'+ '\n\n'
     format.html { redirect_to action: "graph_report", error: 'Debe ingresar la fecha inicial correctamente' }

    else
      @aux=@dateStart
      @aux2=@aux
        @aux2=@aux.split(' ')[1..-1].join(' ')
        @aux2=@aux.chomp(' AM')
        @aux= DateTime.new( (@aux2.split("/")[2]).partition(" ").first.to_i,(@aux2.split("/")[0]).to_i,(@aux2.split("/")[1]).to_i,  (@aux.split(":")[0]).to_i, ( @aux.split(":")[1]).to_i, 0,0)
      @dateBegin = @aux
    end
    if @dateEnd==nil||@dateEnd=="" then
        flash[:error]+= 'Debe ingresar la fecha final correctamente'+ '\n\n'
       format.html { redirect_to action: "graph_report", error: 'Debe ingresar la fecha  final correctamente' }
    else
      @auxEnd=@dateEnd
          @auxEnd2=@auxEnd.split(' ')[1..-1].join(' ')
          @auxEnd2=@auxEnd.chomp(' AM')
          @auxEnd= DateTime.new( (@auxEnd2.split("/")[2]).partition(" ").first.to_i,(@auxEnd2.split("/")[0]).to_i,(@auxEnd2.split("/")[1]).to_i,  (@auxEnd.split(":")[0]).to_i, ( @auxEnd.split(":")[1]).to_i, 0,0)
          @dateFinal= @auxEnd
    end
else
  @dateBegin = Complain.first.created_at
  @dateFinal =Complain.last.created_at
end
@totalCrimes= Complain.where( ' "caseReport" = ?  and complains.created_at BETWEEN ? AND ?',true,  @dateBegin,@dateFinal).joins(:crime).count
puts "zona"
puts @zone
@zones =  Complain.select('DISTINCT zone')

@crimes= Crime.select('DISTINCT code')
@contravertions= Contravertion.select('DISTINCT code')

@zones.select('DISTINCT zone').each do |zone |
  if zone.zone!=nil
    @crimes.each do |crime|
      @crimeAux= Crime.all.where("code =?", crime.code).first
@total_crimes_per_zone.push({
    :crime => @crimeAux.code + ' '+@crimeAux.name,
    :label => zone.zone,
    :value => Complain.where( ' complains.zone = ? and "caseReport" = ? and complains.crime_id = ? and complains.created_at BETWEEN ? AND ?', zone.zone, true, @crimeAux.id, @dateBegin,@dateFinal).joins(:crime).count
})


end
end
end
@zones.select('DISTINCT zone').each do |zone |
  if zone.zone!=nil
    @contravertions.each do |crime|
      @crimeAux= Contravertion.all.where("code =?", crime.code).first
@total_crimes_per_zone.push({
    :crime => @crimeAux.code + ' '+@crimeAux.name,
    :label => zone.zone,
    :value => Complain.where( ' complains.zone = ? and "caseReport" = ? and complains.crime_id = ? and complains.created_at BETWEEN ? AND ?', zone.zone, true, @crimeAux.id, @dateBegin,@dateFinal).joins(:crime).count
})


end
end
end
 format.html
   format.xlsx {
    response.headers['Content-Disposition'] = 'attachment; filename="delitos por zona.xlsx"'
  }
 end
end


    def index_aux
      record_activity("visualizacion de grafica de promedios vs delitos registrados")
          @dateStartToTime =Time.now
    @dateBegin = Complain.order("complains.created_at ASC").first.created_at
    @dateFinal =Complain.order("complains.created_at ASC").last.created_at
    @totalDaysDB = Complain.group("date_trunc('day',complains.created_at)").where('  complains.created_at BETWEEN ? AND ? ', @dateBegin,@dateFinal).count.size

    @totalCrimesDayToday =  Complain.where( 'complains.created_at BETWEEN ? AND ? ' , @dateBegin,@dateBegin).joins(:crime).count
    @date =@dateBegin.change({ hour: 0, min: 0, sec: 1 })

    @dateFinal=@date.change({ hour: 23, min: 59, sec: 59 })
     @average8=Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( ' complains.created_at BETWEEN ? AND ? ', @date,@dateFinal).order("complains.created_at ASC").count
     puts "mmmmmmm"
      @totalTodayDays = Complain.group("date_trunc('day',complains.created_at)").where('EXTRACT(DOW FROM complains.created_at) = ? and complains.created_at BETWEEN ? AND ? ', @dateStartToTime.wday , @dateBegin,@dateFinal).count.size

     puts "mmmmmmm"

 @average4=Complain.where( ' complains.created_at BETWEEN ? AND ? ', @date,@dateFinal).joins(:crime).count


     @i=1
    until @i >= @totalDaysDB  do
      @average = Average.new
      @average.name = "delitos"
      @average.created_at=@date

      @average.average= Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( ' complains.created_at BETWEEN ? AND ? ', @date,@dateFinal).count

      puts  @average.average
     # @average.save!

      if @i==1
      @average1 = Average.new
      @average1.name = "prob"
      @average1.created_at=@date
      @average1.average= 0
    #  @average1.save!
    else
      @average2 = Average.new
      @average2.name = "prob"
      @average2.created_at=@date
      @avg=  Complain.joins("JOIN crimes ON crimes.id = complains.crime_id " ).where( 'complains.created_at BETWEEN ? AND ? ' , @dateBegin,@date).count

      @avg=@avg  /@i.to_f
      @average2.average=@avg.round(2) ;
     # @average2.save!
      end
      @i +=1;
      @date= @date+1.day
      @dateFinal=@dateFinal+1.day



end
@size= Average.all.where( ' name = ? ', 'delitos').count
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
      record_activity("Registro de nueva Denuncia ")
        #if current_user.role==2 ||current_user.role==1
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


        #else
         # redirect_to root_url
        #end
  end
   def index4
=begin
    ComplainsAuxiliar.where('id > ?', 40456).each do |comp|
      if comp.unidadAsignada !=nil
      @comp=comp.unidadAsignada.delete("\n")
      @comp=@comp.gsub(/^A-Za-z0-9-,/, '').gsub('"', '')
      @comp=@comp.strip
       comp.update_attribute(:unidadAsignada, @comp)
     end
       end
 =end
=begin



    Complain.where('zone isnull').each do |comp|
    @aux=  Complainant.where(:complain_id =>comp.id).first
    puts comp.id
    puts "asdadd"
    puts @aux
    puts "dfsdf"
    Complainant.find(@aux.id).destroy
    end
=end
=begin
      Complain.all.each do |comp|
       if comp.complainant==nil
       @complainant= Complainant.new
          if  @complainant.name!=nil
         @complainant.name=comp.complainantNameFromMigrateData
        @complainant.last_name=comp.complainantNameFromMigrateData
        @complainant.ci=000000
      else
        @complainant.name= "no se reporto"
         @complainant.last_name= "no se reporto"
        @complainant.ci=000000
       end
      @complainant.complain_id=comp.id
       @complainant.save!

       end
      end
=end
=begin
@aux = 5062
  PatrolUnit.all.order("id ASC").where("id >=?", @aux).each do |comp|

      @id=comp.id
      @comp=comp.code.delete("\n")
      @comp=@comp.gsub(/^A-Za-z0-9-,/, '').gsub('"', '')
      @comp=@comp.strip
      if PatrolUnit.where("id <= ?",@aux).exists?(code: @comp)
        puts "asada"
        puts @id
        puts "mnasdas"

        @idAux= PatrolUnit.where(:code => @comp).pluck(:id).first.to_i
          puts @idAux
          puts "sdadasdasdsdasd"
      Complain.all.where("patrol_unit_id =?", comp.id).each do |comp|
       comp.update_attribute(:patrol_unit_id, @idAux)

       end

       PatrolUnit.destroy(@id)

      else
      comp.update_attribute(:code,  @comp)
      comp.save!
      end
      @aux+=1

     end
=end
#


=begin


     PatrolUnit.all.order("id ASC").where("id >=5149").each do |comp|

      @id=comp.id
      @comp=comp.code.delete("\n")
      @comp=@comp.gsub(/^A-Za-z0-9-,/, '')
      @comp=@comp.strip
      comp.update_attribute(:code,  @comp)

     end
=end
=begin


     Complain.all.where("patrol_unit_id = 5149").each do |comp|
     comp.update_attribute(:patrol_unit_id, 814)

   end
=end


   end
    def edit
      record_activity("Denuncia editada")
        @complain = Complain.find(params[:id])
        @complainant = Complainant.where(:complain_id => @complain.id).first

    if current_user.role==1
      #  check_box_params[:auxCrime]= @complain.crie.code+ ' ' +@complain.crime.name
         if @complain.crime_id!=nil
           @auxCrime= @complain.crime.code + ' ' + @complain.crime.name
         end
         if @complain.contravertion_id!=nil
           @auxContravertion= @complain.contravertion.code + ' ' + @complain.contravertion.name
         end
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

       @auxCrime= ' '
        Crime.all.each do |comp|
          @crimes << [comp.code + ' ' + comp.name]
        end
       @contravertions = Array.new
       Contravertion.all.each do |comp|
         @contravertions << [comp.code + ' ' + comp.name]
       end

      if check_box_params[:crime]=='1'
          @aux22=params[:auxCrime]
          @aux22= @aux22.gsub(/^A-Za-z0-9-, /, '').gsub("\"", "")
          @aux22=@aux22.split[0...2].join(' ')
          @auxCrime_id = Crime.where(:code =>@aux22).pluck(:id).first.to_i

        end
        if check_box_params[:contravertion]=='1'
          @auxContravertion_id = Contravertion.where(:code =>(params[:auxContravertion]).gsub(/^A-Za-z0-9-, /, '').gsub("\"", "").split[0...2].join(' ')).pluck(:id).first.to_i
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
                 record_average 
                 flash[:notice] = "Denuncia registrada exitosamente"
                 record_activity("Denuncia registrada exitosamente")
                 format.html { redirect_to @complain }
                 format.json { render :show, status: :created, location: @complain }
               end
         else
             record_activity("Denuncia con errores")
            format.html { render :new}
            format.json { render json: @complain.errors, status: :unprocessable_entity }
          end
       end
     end
    def patrol_unit_asign
      @aux=false
       respond_to do |format|
       @complain = Complain.find(params[:complain][:complain_id])
       @patrol_unit_params= params[:patrolUnitAux]
       @newPatrolUnit= PatrolUnit.new
      puts "asdasd c"
      puts @complain
      puts "SDFSFA pa"
      puts @patrol_unit_params
       puts "SDFSFA"
      if @patrol_unit_params!=nil
        @auxPatrolUnit = PatrolUnit.where(:code =>(@patrol_unit_params)).pluck(:id).first.to_i
        if @auxPatrolUnit==0

            @patrol_unit_params= @patrol_unit_params.delete("\n")
            @patrol_unit_params=@patrol_unit_params.gsub(/^A-Za-z0-9-,/, '')
            @patrol_unit_params=@patrol_unit_params.strip
            @auxPatrolUnit = PatrolUnit.where(:code =>(@patrol_unit_params)).pluck(:id).first.to_i
          if  @auxPatrolUnit==0
             @newPatrolUnit.code = @patrol_unit_params
             @newPatrolUnit.name= ""
             if @newPatrolUnit.valid?
              @aux=true
              @newPatrolUnit.save!
              @complain.update_attribute(:patrol_unit_id, @newPatrolUnit.id )
             else
              @aux=false
              flash[:error]= 'Error al asignar unidad'+ '\n\n'
             format.html { redirect_to action: "show", error: 'Error al asignar unidad' ,:patrolUnitAsign => true, :patrolUnitAux =>  @patrol_unit_params}

             end
          else
             @complain.update_attribute(:patrol_unit_id, @auxPatrolUnit )
             @aux=true
             flash[:notice]  = "Se asigno la unidad seleccionada"
        format.html { redirect_to action: "index", notice: 'Se asigno la unidad seleccionada'}
          end
        else
          @complain.update_attribute(:patrol_unit_id,  @auxPatrolUnit)
          @aux=true
          flash[:notice]  = "Se asigno la unidad seleccionada"
        format.html { redirect_to action: "index", notice: 'Se asigno la unidad seleccionada'}
        end
      end

       if @aux==true

        flash[:notice]  = "Se asigno la unidad seleccionada"
        format.html { redirect_to action: "index", notice: 'Se asigno la unidad seleccionada'}

       else
          flash[:error]= 'Error al asignar unidad'+ '\n\n'
          format.html { redirect_to action: "show", error: 'Error al asignar unidad' ,:patrolUnitAsign => true, :patrolUnitAux =>  @patrol_unit_params}
       end
    end
end
    def case_report
      @complain = Complain.find(params[:complain][:complain_id])

    end
    def index_logs
       if user_signed_in?

            @role_current_user = current_user.role

          if   @role_current_user==1
            record_activity("Visualizacion de logs")
            @activities= ActivityLog.all.paginate(:page => params[:page], :per_page => 10).order("created_at DESC")
          end
        end
    end

    def update

     @caseReport= params[:complain][:caseReport]
      @patrolUnitAux=  check_box_params[:patrolUnitAux]
     puts params
     @commit= params[:complain][:commit]
      if @commit==nil
        @commit=params[:commit]
      end
      @commit=@commit.delete("\n")
      @commit=@commit.gsub(/^A-Za-z0-9-,/, '')
      @commit=@commit.strip
      puts "commit"
      puts @commit
      @observationsAux=params[:observationsAux]
      @observations_params=params[:complain][:observations]
      respond_to do |format|

      if @caseReport!=nil
        puts "entra a reporte"
        flash[:error] =""
       @complain = Complain.find(params[:complain][:complain_id])
       @patrol_unit_params= params[:complain][:patrolUnitAux]

       @protagonists=params[:complain][:protagonists]
       @shortReport=params[:complain][:shortReport]
       @derivationCase=params[:complain][:derivationCase]
      if @caseReport=='yes'
        puts "entra1"
        if params[:complain][:protagonists]==""
         #redirect_to action: "show", notice: 'Falta llenar el campo protagosistas' }
         flash[:error]  = "Debe registrar el campo protagonistas" + '\n\n'
              format.html { redirect_to action: "show", error: 'Debe registrar el campo protagonistas' ,:caseReport => true, :protagonists =>  @protagonists}
           #redirect_to show_path, :flash => { :error => "Error no existe unidad" }
        elsif  params[:complain][:shortReport]==""
          flash[:error]+= 'Debe registrar el campo breve informe'+ '\n\n'
           format.html { redirect_to action: "show", error: 'Debe registrar el campo breve informe' ,:caseReport => true, :protagonists =>  @protagonists}
        elsif  @derivationCase==""
           flash[:error]+= 'Debe registrar el campo derivacion del caso '+ '\n\n'
           format.html { redirect_to action: "show", error: 'Debe registrar el campo derivacion del caso' ,:caseReport => true, :protagonists =>  @protagonists}

        end
        if @protagonists!=""&& @shortReport!=""&&@derivationCase!=""
           @complain.update_attributes(:caseReport=> true, :shortReport =>@shortReport,:protagonists=>@protagonists,:derivationCase=>@derivationCase )
           record_activity("Registro de reporte de caso")
          format.html { redirect_to action: "index", notice: 'Reporte del caso registardo' }
        end
      elsif @caseReport=='no'
         @complain.update_attribute(:caseReport, false)

           format.html { redirect_to action: "index", notice: 'Reporte del caso registardo' }

      end

      end

      if @commit == "Registrar observaciones"
      if @observations_params!=""
        @complain = Complain.find(params[:id])

         @complain.update_attribute(:observations, params[:observations] )
          format.html { redirect_to action: "index", notice: 'Observaciones registradas' }

      elsif  @observations_params==""|| @observations_params==nil
         flash[:error]= 'Debe registrar el campo observaciones no se debe dejar en blanco'+ '\n\n'
           format.html { redirect_to action: "show", error: 'Debe registrar el  campo observaciones no se debe dejar en blanco' ,:observationsAux => true, :observations=>  @observations_params}

      end

      end
      if  @commit.eql?'Registrar denuncia'
        puts "entra up"
      @complain = Complain.find(params[:id])


      @complainant = Complainant.where(:complain_id => @complain.id).first
      if @complainant==nil
          @complainant = Complainant.new(complainant_params)
         # @complainant = Complainant.new()
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

        @auxCrime_id = Crime.where(:code =>(params[:auxCrime]).gsub('"', '').split[0...2].join(' ')).pluck(:id).first.to_i
        puts Crime.where(:code =>(params[:auxCrime]).gsub('"', '').split[0...2].join(' ')).pluck(:id).first.to_i
      end
      if check_box_params[:contravertion]=='1'
        @auxContravertion_id = Contravertion.where(:code =>(params[:auxContravertion]).gsub('"', '').split[0...2].join(' ')).pluck(:id).first.to_i
      end
      if @auxCrime_id!=0
        @complain.crime_id = @auxCrime_id
      end
      if @auxContravertion_id!=0
        @complain.contravertion_id = @auxContravertion_id
      end




      @crime_id= @complain.crime_id
      @contravertion_id=@complain.contravertion_id

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
                record_activity("denuncia modificada")
                format.html { redirect_to action: "show", notice: 'Denuncia registrada exitosamente up' }
                format.json { render :show, status: :created, location: @complain }
              end
        else
           format.html { render :new}
           format.json { render json: @complain.errors, status: :unprocessable_entity }
         end
          else
      puts "entra aqui 3"
      puts @commit
      puts "ADadsd"
      puts @commit.eql?"Registar denuncia"
      puts "SDSFfffffffff"
      puts @commit.eql?'Registar denuncia '
      @commit.each_byte do |c|
        puts c
    end
    puts "hola"
    "Registar denuncia".each_byte do |c|
    puts c
end
puts "hola"
          end

   end
  end

    def destroy
      @complain.destroy
      respond_to do |format|
        record_activity("Denuncia eliminada")
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
        params.require(:complain).permit( :contravertion,:crime, :crime_checkbox , :contravertion_checkbox, :crimeAux,  :crime_id,:contravertion_id,:auxCrime, :auxContravertion, :observations,:patrol_unit, :turnHour ,:zoneCrime, :observationsAux,:patrolUnitAux)
      end
      def complainant_params
       params.require(:complainant).permit(:name, :last_name,:ci, :phone, :address,:observationsAux)
      end
  end
